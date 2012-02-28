include LanguagesHelper
include IdiomHelper
include SetHelper
include TranslationHelper

class TermsController < ApplicationController
  before_filter :authenticate_user!

  caches_page :index, :show, :first_review, :review

  can_edit_on_the_spot
  
  def index
    @translations = []
    @q = nil
    @page = 1
  end

  def search
    @page = params[:page]
    @q = params[:q]
    return redirect_to terms_path if @q.blank?

    @q.gsub!("%", "")
    @page ||= 1

    @translations = Translation.all_sorted_by_idiom_language_and_form_with_like_filter @q.split(','), @page.to_i

    render :index
  end

  def new
    @translations = []
    @translations << Translation.new
    @translations << Translation.new

    @set_id = params[:set_id] if params[:set_id]

    @languages = Language.all
  end

  def create
    translation_params = params[:translation]
    @translations = []

    invalid_count = 0
    translation_params.each do |translation|
      t = Translation.new(translation[1])
      
      unless t.language_id.nil? and t.form.nil? and t.pronunciation.nil?
        unless t.form.empty? and t.pronunciation.empty?
          @translations << t

          t.valid?
          unless t.errors.count <= 1
            invalid_count = invalid_count + 1
          end
        end
      end
    end


    if invalid_count == 0 and @translations.count >= 2
      #all translation_params are valid!
      idiom = Idiom.create

      @translations.each do |to|
        to.idiom_id = idiom.id
        to.save!
      end


      #scan for related translations of the same language
      @translations.each do |translation|
        RelatedTranslations::create_relationships_for_translation translation
      end


      #if we have a set_id. we should link the term to that set
      params["translations"] ||= {}
      params["translations"]["set_id"] ||= ""
      unless params["translations"]["set_id"].empty?
        add_term_to_set params["translations"]["set_id"], idiom.id
        
        expire_page(:controller => 'terms', :action => 'index')
        expire_page(:controller => 'sets', :action => 'show' ,:id =>  params["translations"]["set_id"])
        @translations.each do |translation|
          expire_page(:controller => 'languages', :action => 'show', :id => translation.language_id)
        end

        success_redirect_to t('notice.term-create'), new_set_set_term_path(params["translations"]["set_id"]) and return
      else
        expire_page(:controller => 'terms', :action => 'index')
        success_redirect_to t('notice.term-create'), new_term_path and return
      end
    end

    while @translations.count < 2
      @translations << Translation.new
      error t('notice.term-insuffient-translations') if no_user_errors?
    end

    error t('notice.term-translations-incomplete') if no_user_errors?

    @languages = Language.only_enabled
  end

  def update
    @idiom = Idiom.find(params[:id])

    translation_params = params[:translation]
    @translations = []

    invalid_count = 0
    translation_params.each do |translation|
      t = nil
      begin
        t = Translation.find(translation[1][:id])
        t.update_attributes(translation[1])
      rescue
        t = Translation.new(translation[1])
      end

      unless t.language_id.nil? and t.form.nil? and t.pronunciation.nil?
        unless t.language_id == 0 and t.form.empty? and t.pronunciation.empty?
          @translations << t
          if t.invalid?
            if (t.errors.count == 1 and t.errors[:idiom_id].empty?) or (t.errors.count > 1)
              invalid_count = invalid_count + 1
            end
          end
        end
      end
    end

    if invalid_count == 0 and @translations.count >= 2
      #all translation_params are valid!
      @translations.each do |to|
        to.idiom_id = @idiom.id
        to.save!
      end


      #scan for related translations of the same language
      @translations.each do |translation|
        RelatedTranslations::rebuild_relationships_for_translation translation
      end



      expire_page(:controller => 'terms', :action => 'index')
      SetTerms.where(:term_id => @idiom.id).each do |set_term|
        expire_page(:controller => 'sets', :action => 'show' ,:id => set_term.set_id)
      end
      @translations.each do |translation|
        expire_page(:controller => 'languages', :action => 'show', :id => translation.language_id)
      end

      success_redirect_to t('notice.term-update'), term_path(@idiom.id)
    end

    while @translations.count < 2
      @translations << Translation.new
      error t('notice.term-insuffient-translations') if no_user_errors?
    end

    error t('notice.term-translations-incomplete') if no_user_errors?

    @languages = Language.all
  end

  def add_translation
    @translation = Translation.new
    @i = params[:i]
    @languages = Language.all
  end

  def show
    if Idiom::exists? params[:id]
      @translations = all_translations_sorted_correctly_for_idiom params[:id]
      if @translations.empty?
        error_redirect_to t('notice.term-no-translations'), terms_path
      end
    else
      error_redirect_to t('notice.not-found'), terms_path
    end

    set_ids = SetTerms.where(:term_id => params[:id]).select {|st| st.set_id}
    @sets = Sets.where(:id => set_ids)
  end

  def edit
    error_redirect_to t('notice.not-found'), terms_path and return unless idiom_exists? params[:id]
    
    @idiom = Idiom.find(params[:id])
    if Idiom::exists? params[:id]
      @translations = all_translations_sorted_correctly_for_idiom params[:id]
      if @translations.empty?
        error_redirect_to t('notice.term-no-translations'), terms_path
      end
    else
      error_redirect_to t('notice.not-found'), terms_path
    end

    @languages = Language.all
  end

  def select
    @idiom_id = params[:idiom_id]
    @translation_id = params[:translation_id]
    return error_redirect_to t('notice.not-found'), terms_path unless idiom_exists? @idiom_id
    return error_redirect_to t('notice.not-found'), terms_path unless translation_exists? @translation_id

    @page = params[:page]
    @page ||= 1
    @q = params[:q]


    if @q.nil?
      @q = Translation.find(@translation_id).form
    end

    
    @q.gsub!("%", "")
    @translations = Translation.all_sorted_by_idiom_language_and_form_with_like_filter @q.split(','), @page.to_i
#    @translations = Translation.joins(:languages).order(:idiom_id).order(:name).order(:form).where('idiom_id != :idiom_id and languages.enabled = true', :idiom_id => params[:idiom_id])
  end

  def select_for_set
    set_id = params[:set_id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id


    @page = params[:page]
    @page ||= 1
    @q = params[:q]


    if @q.nil?
      @translations = []
    else
      @q.gsub!("%", "")
      @translations = Translation.all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set_id, @q.split(','), @page
    end
  end

  def first_review
    begin
      native_language_id = current_user.native_language_id

      error_redirect_to t('notice.not-found'), language_set_path(params[:language_id], params[:set_id]) and return unless idiom_exists? params[:id]
      error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:set_id]
      error_redirect_to t('notice.not-found'), user_index_path and return unless language_is_valid? params[:language_id]

      @term = Idiom.find(params[:id])

      # get all translations in the term, that match the learned language
      @learned_translations_in_idiom = Translation.joins(:languages).order(:form).where(:language_id => params[:language_id], :idiom_id => params[:id])
      learned_translations_in_idiom = @learned_translations_in_idiom.map{|t| t.id}
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?

      # get all translations in the term, that match the users native language
      @native_translations = Translation.joins(:languages).order(:form).where(:language_id => native_language_id, :idiom_id => params[:id])


      @audio = "front"
      @typed = false
      @native = "back"
      @learned = "back"

      #get related count and idioms
      @learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id]
      @related_count = @learned_translations.count
      @idioms = get_idioms_from_translations @learned_translations

      #send languages
      @learned_language = Language.find(params[:language_id])
      @native_language = Language.find(current_user.native_language_id)


      if detect_browser == "mobile_application"
        render "learn.mobile"
      end
    rescue
      puts "An unknown error occurred for user #{current_user.email} with params: #{params}"
    end
  end
  
  def review
    begin
      native_language_id = current_user.native_language_id
      
      error_redirect_to t('notice.not-found'), language_set_path(params[:language_id], params[:set_id]) and return unless idiom_exists? params[:id]
      error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:set_id]
      error_redirect_to t('notice.not-found'), user_index_path and return unless language_is_valid? params[:language_id]

      @term = Idiom.find(params[:id])

      # get all translations in the term, that match the learned language
      @learned_translations_in_idiom = Translation.joins(:languages).order(:form).where(:language_id => params[:language_id], :idiom_id => params[:id])
      learned_translations_in_idiom = @learned_translations_in_idiom.map{|t| t.id}
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
      
      # get all translations in the term, that match the users native language
      @native_translations = Translation.joins(:languages).order(:form).where(:language_id => native_language_id, :idiom_id => params[:id])


      # configure display based on review mode
      @audio = "back"
      @typed = false
      @native = "not set"
      @learned = "not set"
      @related_count = nil
      if params[:review_mode]["listening"]
        @audio = "front"
        @native = "back"
        @learned = "back"

        related_translation_link = {:audible => true}
      end
      if params[:review_mode]["reading"]
        @learned = "both"
        @native = "back"

        related_translation_link = {:written => true}
      end
      if params[:review_mode]["translating"]
        @learned = "back"
        @native = "front"
        related_translation_link = {:meaning => true}
      end
      if params[:review_mode]["typing"]
        @typed = true
      end
      

      #get related count and idioms
      @learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id], related_translation_link
      @related_count = @learned_translations.count
      @idioms = get_idioms_from_translations @learned_translations


      #send languages
      @learned_language = Language.find(params[:language_id])
      @native_language = Language.find(current_user.native_language_id)


      #send review text
      @review_text = {}
      @review_text["reading"] = "I knew what this meant in #{@native_language.name}"
      @review_text["speaking"] = "I correctly pronounced this"
      @review_text["writing"] = "I correctly wrote this"
      @review_text["typing"] = "I correctly typed this"
      @review_text["listening"] = "I knew what this meant in #{@native_language.name}"
      @review_text["translating"] = "I knew what this meant in #{@learned_language.name}"
    rescue Exception => e
      puts "An unknown error occurred for user #{current_user.email} with params: #{params}"
      puts e.message
      puts e.backtrace.inspect
      puts "*" * 80
    end
  end

  def add_to_set
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), user_index_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), user_index_path and return unless idiom_exists? term_id

    add_term_to_set set_id, term_id

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-added'), :back
  end

  def remove_from_set
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), user_index_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), user_index_path and return unless idiom_exists? term_id

    SetTerms.where(:set_id => set_id, :term_id => term_id).each do |set_term|
      set_term.delete
    end

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-removed'), set_path(set_id)
  end

  def next_chapter
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    error_redirect_to t('notice.not-found'), set_path(set_id) and return if set_term.empty?

    existing_chapter = set_term.first.chapter
    set_term.first.chapter = set_term.first.chapter + 1
    set_term.first.save

    if SetTerms.where(:set_id => set_id, :chapter => existing_chapter).empty?
      SetTerms::decrement_chapters_for_set_after_chapter set_id, existing_chapter
    end

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-next-chapter'), set_path(set_id)
  end

  def prev_chapter
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    error_redirect_to t('notice.not-found'), set_path(set_id) and return if set_term.empty?

    set_term.first.chapter = set_term.first.chapter - 1
    set_term.first.save

    if set_term.first.chapter == 0
      SetTerms::increment_chapters_for_set set_id
    end

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-prev-chapter'), set_path(set_id)
  end

  def next_position
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    error_redirect_to t('notice.not-found'), set_path(set_id) and return if set_term.empty?


    current_position = set_term.first.position
    next_term = SetTerms.where(:set_id => set_id, :chapter => set_term.first.chapter, :position => current_position + 1)

    unless next_term.empty?
      set_term.first.position = set_term.first.position + 1
      next_term.first.position = next_term.first.position - 1

      set_term.first.save
      next_term.first.save
    end

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-next-position'), set_path(set_id)
  end

  def prev_position
    set_id = params[:set_id]
    term_id = params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id
    error_redirect_to t('notice.not-found'), set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    error_redirect_to t('notice.not-found'), set_path(set_id) and return if set_term.empty?


    current_position = set_term.first.position
    prev_term = SetTerms.where(:set_id => set_id, :chapter => set_term.first.chapter, :position => current_position - 1)

    unless prev_term.empty?
      set_term.first.position = set_term.first.position - 1
      prev_term.first.position = prev_term.first.position + 1

      set_term.first.save
      prev_term.first.save
    end

    expire_page(:controller => 'sets', :action => 'show' ,:id => set_id)
    success_redirect_to t('notice.set-idiom-prev-position'), set_path(set_id)
  end

  def record_review
    error_redirect_to t('notice.not-found'), review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return unless idiom_exists? params[:id]
    error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:set_id]
    error_redirect_to t('notice.not-found'), user_index_path and return unless language_is_valid? params[:language_id]
    error_redirect_to t('notice.user-not-learning-language'), language_path(params[:language_id]) and return unless user_is_learning_language? params[:language_id], current_user.id
    error_redirect_to t('notice.review-mode-not-set'), review_language_set_path(params[:language_id], params[:set_id]) and return if params[:review_mode].nil?

    params[:review_mode].gsub!("%20","")
    params[:review_mode].gsub!(" ","")
    params[:review_mode].gsub!("\t","")

    related_translation_link = {:audible => true} if params[:review_mode]["listening"]
    related_translation_link = {:written => true} if params[:review_mode]["reading"]
    related_translation_link = {:meaning => true} if params[:review_mode]["translating"]

    learned_translations_in_idiom = Translation.joins(:languages).order(:form).where(:language_id => params[:language_id], :idiom_id => params[:id])
    learned_translations_in_idiom = learned_translations_in_idiom.map{|t| t.id}

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
    learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id], related_translation_link

    sync_due_times = []    
    get_idioms_from_translations(learned_translations).each do |idiom|
      schedule = UserIdiomSchedule.where(:user_id => current_user.id, :idiom_id => idiom.id, :language_id => params[:language_id])
      error_redirect_to t('notice.not-found'), review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if schedule.empty?
      schedule = schedule.first


      params[:duration] ||= 0
      params[:elapsed] ||= 0
      duration_in_seconds = params[:duration].to_i / 1000
      elapsed_in_seconds = params[:elapsed].to_i / 1000

      now = Time.now
      UserIdiomDueItems.where(:user_idiom_schedule_id => schedule.id).each do |due_item|
        review_start_time = now - elapsed_in_seconds < due_item.due ? due_item.due : now - elapsed_in_seconds

        review = UserIdiomReview.new
        review.due = due_item.due
        review.review_start = review_start_time
        review.reveal = review_start_time + duration_in_seconds
        review.user_id = current_user.id
        review.idiom_id = idiom.id
        review.language_id = params[:language_id]
        review.result_recorded = now
        review.interval = due_item.interval

        if due_item.review_type == UserIdiomReview.to_review_type_int("reading")
          next unless params[:review_mode]["reading"]
          review.review_type = UserIdiomReview::READING
          review.success = params[:skip].nil? ? to_boolean(params[:reading]) : true
        end
        if due_item.review_type == UserIdiomReview.to_review_type_int("typing")
          next unless params[:review_mode]["typing"]
          review.review_type = UserIdiomReview::TYPING
          review.success = params[:skip].nil? ? to_boolean(params[:typing]) : true
        end
        if due_item.review_type == UserIdiomReview.to_review_type_int("speaking")
          next unless params[:review_mode]["speaking"]
          review.review_type = UserIdiomReview::SPEAKING
          review.success = params[:skip].nil? ? to_boolean(params[:speaking]) : true
        end
        if due_item.review_type == UserIdiomReview.to_review_type_int("writing")
          next unless params[:review_mode]["writing"]
          review.review_type = UserIdiomReview::WRITING
          review.success = params[:skip].nil? ? to_boolean(params[:writing]) : true
        end
        if due_item.review_type == UserIdiomReview.to_review_type_int("listening")
          next unless params[:review_mode]["listening"]
          review.review_type = UserIdiomReview::HEARING
          review.success = params[:skip].nil? ? to_boolean(params[:listening]) : true
        end
        if due_item.review_type == UserIdiomReview.to_review_type_int("translating")
          next unless params[:review_mode]["translating"]
          review.review_type = UserIdiomReview::TRANSLATING
          review.success = params[:skip].nil? ? to_boolean(params[:translating]) : true
        end

        if review.success
          if params[:skip].nil?
            due_item.interval = CardTiming.get_next(due_item.interval).seconds
          else
            due_item.interval = CardTiming.get_next(CardTiming.get_next(due_item.interval).seconds).seconds
          end
        else
          due_item.interval = CardTiming.get_first.seconds
        end

        sync_due_times[due_item.review_type] ||= Time.now + due_item.interval
        due_item.due = sync_due_times[due_item.review_type]
        
        review.save!
        due_item.save!
      end
    end

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode])
  end

  def record_first_review
    error_redirect_to t('notice.not-found'), review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return unless idiom_exists? params[:id]
    error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:set_id]
    error_redirect_to t('notice.not-found'), user_index_path and return unless language_is_valid? params[:language_id]
    redirect_to language_path(params[:language_id]) and return unless user_is_learning_language? params[:language_id], current_user.id
    redirect_to review_language_set_path(params[:language_id], params[:set_id]) and return if params[:review_mode].nil?


    learned_translations_in_idiom = Translation.joins(:languages).order(:form).where(:language_id => params[:language_id], :idiom_id => params[:id])
    learned_translations_in_idiom = learned_translations_in_idiom.map{|t| t.id}

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
    learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id]

    get_idioms_from_translations(learned_translations).each do |idiom|
      schedule = UserIdiomSchedule.where(:user_id => current_user.id, :idiom_id => idiom.id, :language_id => params[:language_id])
      error_redirect_to t('notice.not-found'), review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if schedule.empty?
      schedule = schedule.first

      # as we are seeing a new term; we need to sync related terms to this one. This means that all we be seen again in real soon
      next_interval = CardTiming.get_next(CardTiming.get_first.seconds).seconds        #sync to second interval
      next_due = Time.now + next_interval
      UserIdiomReview::REVIEW_TYPES.each do |review_type|
        due_item = get_first UserIdiomDueItems.where(:user_idiom_schedule_id => schedule.id, :review_type => review_type)
        due_item ||= UserIdiomDueItems.new(:user_idiom_schedule_id => schedule.id, :review_type => review_type)

        due_item.interval = next_interval
        due_item.due = next_due
        due_item.save!
      end
    end

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode])
  end
end
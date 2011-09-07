include LanguagesHelper
include IdiomHelper
include SetHelper
include TranslationHelper

class TermsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @translations = all_translations_sorted_correctly
  end

  def new
    @translations = []
    @translations << Translation.new
    @translations << Translation.new

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
          if t.valid?
          else
            invalid_count = invalid_count + 1
          end
        end
      end
    end


    if invalid_count == 0 and @translations.count >= 2
      #all translation_params are valid!
      idiom = Idiom.create

      @translations.each do |to|
        to.save!

        IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => to.id)
      end


      #scan for related translations of the same language
      @translations.each do |translation|
        RelatedTranslations::create_relationships_for_translation translation
      end

      
      link = self.class.helpers.link_to('Click here to edit.', edit_term_path(idiom.id))
      flash[:success] = "Related terms created. #{link}"


      #if we have a set_id. we should link the term to that set
      if params[:set_id]
        add_term_to_set params[:set_id], idiom.id
        
        redirect_to new_set_set_term_path(params[:set_id]) and return
      else
        redirect_to new_term_path and return
      end
    end

    while @translations.count < 2
      @translations << Translation.new
      flash[:failure] = "At least two translations need to be supplied" if flash[:failure].nil?
    end


    flash[:failure] = "All translations need to be complete" if flash[:failure].nil?

    @languages = Language.all
  end

  def update
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
          if t.valid?
          else
            invalid_count = invalid_count + 1
          end
        end
      end
    end

    if invalid_count == 0 and @translations.count >= 2
      #all translation_params are valid!
      idiom = Idiom.find(params[:id])

      @translations.each do |to|
        to.save!

        if IdiomTranslation.where(:idiom_id => idiom.id, :translation_id => to.id).empty?
          IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => to.id)
        end
      end


      #scan for related translations of the same language
      @translations.each do |translation|
        RelatedTranslations::rebuild_relationships_for_translation translation
      end


      link = self.class.helpers.link_to('Click here to view.', edit_term_path(idiom.id))
      flash[:success] = "Related terms created. #{link}"
      redirect_to term_path(idiom.id) and return
    end

    while @translations.count < 2
      @translations << Translation.new
      flash[:failure] = "At least two translations need to be supplied" if flash[:failure].nil?
    end


    flash[:failure] = "All translations need to be complete" if flash[:failure].nil?

    @languages = Language.all
  end

  def add_translation
    @translation = Translation.new
    @i = params[:i]
  end

  def show
    get_idiom_translations
  end

  def edit
    redirect_to terms_path and return unless idiom_exists? params[:id]
    
    @idiom = Idiom.find(params[:id])
    get_idiom_translations

    @languages = Language.all
  end

  def select
    return redirect_to terms_path unless idiom_exists? params[:idiom_id]
    return redirect_to terms_path unless translation_exists? params[:translation_id]

    @translations = Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).where(['idiom_translations.idiom_id != ?', params[:idiom_id]])
  end

  def select_for_set
    set_id = params[:set_id]
    redirect_to sets_path and return unless set_exists? set_id

    @translations = []
    all_translations_sorted_correctly.each do |translation|
      next if SetTerms.where(:set_id => set_id, :term_id => translation.idiom_translations.idiom_id).count > 0

      @translations << translation
    end
  end

  def first_review
    begin
      native_language_id = current_user.native_language_id

      redirect_to language_set_path(params[:language_id], params[:set_id]) and return unless idiom_exists? params[:id]
      redirect_to language_path(params[:language_id]) and return unless set_exists? params[:set_id]
      redirect_to user_index_path and return unless language_is_valid? params[:language_id]

      @term = Idiom.find(params[:id])

      # get all translations in the term, that match the learned language
      @learned_translations_in_idiom = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => params[:language_id], :idiom_translations => {:idiom_id => params[:id]})
      learned_translations_in_idiom = @learned_translations_in_idiom.map{|t| t.id}
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?

      # get all translations in the term, that match the users native language
      @native_translations = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => native_language_id, :idiom_translations => {:idiom_id => params[:id]})

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
      ap "hmmm"
    end
  end
  
  def review
    begin
      native_language_id = current_user.native_language_id
      
      redirect_to language_set_path(params[:language_id], params[:set_id]) and return unless idiom_exists? params[:id]
      redirect_to language_path(params[:language_id]) and return unless set_exists? params[:set_id]
      redirect_to user_index_path and return unless language_is_valid? params[:language_id]

      @term = Idiom.find(params[:id])

      # get all translations in the term, that match the learned language
      @learned_translations_in_idiom = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => params[:language_id], :idiom_translations => {:idiom_id => params[:id]})
      learned_translations_in_idiom = @learned_translations_in_idiom.map{|t| t.id}
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
      
      # get all translations in the term, that match the users native language
      @native_translations = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => native_language_id, :idiom_translations => {:idiom_id => params[:id]})


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
        @learned = "front"
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

      
      if detect_browser == "mobile_application"
        render "learn.mobile"
      end
    rescue
      ap "hmmm"
    end
  end

  def add_to_set
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to user_index_path and return unless set_exists? set_id
    redirect_to user_index_path and return unless idiom_exists? term_id

    add_term_to_set set_id, term_id

    redirect_to set_path(set_id)
  end

  def remove_from_set
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to user_index_path and return unless set_exists? set_id
    redirect_to user_index_path and return unless idiom_exists? term_id

    SetTerms.where(:set_id => set_id, :term_id => term_id).each do |set_term|
      set_term.delete
    end

    redirect_to set_path(set_id)
  end

  def next_chapter
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to sets_path and return unless set_exists? set_id
    redirect_to set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    redirect_to set_path(set_id) and return if set_term.empty?

    existing_chapter = set_term.first.chapter
    set_term.first.chapter = set_term.first.chapter + 1
    set_term.first.save

    if SetTerms.where(:set_id => set_id, :chapter => existing_chapter).empty?
      SetTerms::decrement_chapters_for_set_after_chapter set_id, existing_chapter
    end

    redirect_to set_path(set_id)
  end

  def prev_chapter
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to sets_path and return unless set_exists? set_id
    redirect_to set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    redirect_to set_path(set_id) and return if set_term.empty?

    set_term.first.chapter = set_term.first.chapter - 1
    set_term.first.save

    if set_term.first.chapter == 0
      SetTerms::increment_chapters_for_set set_id
    end

    redirect_to set_path(set_id)
  end

  def next_position
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to sets_path and return unless set_exists? set_id
    redirect_to set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    redirect_to set_path(set_id) and return if set_term.empty?


    current_position = set_term.first.position
    next_term = SetTerms.where(:set_id => set_id, :chapter => set_term.first.chapter, :position => current_position + 1)

    unless next_term.empty?
      set_term.first.position = set_term.first.position + 1
      next_term.first.position = next_term.first.position - 1

      set_term.first.save
      next_term.first.save
    end

    redirect_to set_path(set_id)
  end

  def prev_position
    set_id = params[:set_id]
    term_id = params[:id]
    redirect_to sets_path and return unless set_exists? set_id
    redirect_to set_path(set_id) and return unless idiom_exists? term_id

    set_term = SetTerms.where(:set_id => set_id, :term_id => term_id)
    redirect_to set_path(set_id) and return if set_term.empty?


    current_position = set_term.first.position
    prev_term = SetTerms.where(:set_id => set_id, :chapter => set_term.first.chapter, :position => current_position - 1)

    unless prev_term.empty?
      set_term.first.position = set_term.first.position - 1
      prev_term.first.position = prev_term.first.position + 1

      set_term.first.save
      prev_term.first.save
    end

    redirect_to set_path(set_id)
  end

  def record_review
    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return unless idiom_exists? params[:id]
    redirect_to language_path(params[:language_id]) and return unless set_exists? params[:set_id]
    redirect_to user_index_path and return unless language_is_valid? params[:language_id]
    redirect_to language_path(params[:language_id]) and return unless user_is_learning_language? params[:language_id], current_user.id
    redirect_to review_language_set_path(params[:language_id], params[:set_id]) and return if params[:review_mode].nil?


    related_translation_link = {:audible => true} if params[:review_mode]["listening"]
    related_translation_link = {:written => true} if params[:review_mode]["reading"]
    related_translation_link = {:meaning => true} if params[:review_mode]["translating"]

    learned_translations_in_idiom = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => params[:language_id], :idiom_translations => {:idiom_id => params[:id]})
    learned_translations_in_idiom = learned_translations_in_idiom.map{|t| t.id}

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
    learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id], related_translation_link

    sync_due_times = []    
    get_idioms_from_translations(learned_translations).each do |idiom|
      schedule = UserIdiomSchedule.where(:user_id => current_user.id, :idiom_id => idiom.id, :language_id => params[:language_id])
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if schedule.empty?
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
          due_item.interval = CardTiming.get_next(due_item.interval).seconds
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
    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return unless idiom_exists? params[:id]
    redirect_to language_path(params[:language_id]) and return unless set_exists? params[:set_id]
    redirect_to user_index_path and return unless language_is_valid? params[:language_id]
    redirect_to language_path(params[:language_id]) and return unless user_is_learning_language? params[:language_id], current_user.id
    redirect_to review_language_set_path(params[:language_id], params[:set_id]) and return if params[:review_mode].nil?


    learned_translations_in_idiom = Translation.joins(:languages, :idiom_translations).order(:form).where(:language_id => params[:language_id], :idiom_translations => {:idiom_id => params[:id]})
    learned_translations_in_idiom = learned_translations_in_idiom.map{|t| t.id}

    redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if learned_translations_in_idiom.empty?
    learned_translations = RelatedTranslations::get_related learned_translations_in_idiom, current_user.id, params[:language_id]

    get_idioms_from_translations(learned_translations).each do |idiom|
      schedule = UserIdiomSchedule.where(:user_id => current_user.id, :idiom_id => idiom.id, :language_id => params[:language_id])
      redirect_to review_language_set_path(params[:language_id], params[:set_id], :review_mode => params[:review_mode]) and return if schedule.empty?
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
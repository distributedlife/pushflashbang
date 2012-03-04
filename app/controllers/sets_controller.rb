include SetHelper
include LanguagesHelper
include ReviewTypeHelper
  
class SetsController < ApplicationController
  before_filter :authenticate_user!

  caches_page :index, :show

  can_edit_on_the_spot

  def new
    @set_name = SetName.new
  end

  def user_sets
    @language = Language.find(params[:language_id])
    @user_sets = []
    @sets = []
    set_ids = []

    Sets.all.each do |set|
      next unless set_ids[set.id].nil?
      set_ids[set.id] = set.id

      SetTerms.where(:set_id => set.id).each do |set_terms|
        next if Translation.where(:language_id => @language.id, :idiom_id => set_terms.term_id).empty?

        if UserSets.where(:set_id => set.id, :user_id => current_user.id, :language_id => @language.id).empty?
          @sets << set
        else
          @user_sets << set
        end

        break
      end
    end
  end

  def user_goals
    @set_id = params[:id]
    @user_goals = UserSets::get_for_user_and_set_where_learning_language current_user.id, @set_id
    @user_languages = current_user.languages.order(:name).where(:enabled => true).select { |language| language.supports_set? @set_id}
  end

  def create
    @set_name = SetName.new(params[:set_name])
    @set_name.sets_id = 1
    if @set_name.invalid?
      @set_name.sets_id = nil
      return
    end

    set = Sets.create
    @set_name.sets_id = set.id
    @set_name.save
    
    expire_page(:controller => 'sets', :action => 'index')

    success_redirect_to t('notice.set-create'), set_path(set.id)
  end

  def show 
    error_redirect_to t('notice.not-found'), sets_path and return if !set_exists? params[:id]

    @set = Sets.find(params[:id])
    @set_names = SetName.order(:name).where(:sets_id => params[:id])
    redirect_to sets_path and return if @set_names.empty?

    @chapters = SetTerms.select(:chapter).where(:set_id => params[:id]).group(:chapter).order(:chapter)
  end

  def show_chapter
    params[:chapter] ||= 0
  end

  def index
    @sets = Sets.all
  end

  def add_set_name
    @set_name = SetName.new
    @i = params[:i]
  end

  def delete_set_name
    error_redirect_to t('notice.not-found'), sets_path and return if !set_exists? params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return if !set_name_exists? params[:id], params[:set_name_id]
    
    if SetName.where(:sets_id => params[:id]).count == 1
      error_redirect_to t('notice.set-cant-delete-name'), :back
      return
    end

    set_name = SetName.find params[:set_name_id]
    set_name.delete

    expire_page(:controller => 'sets', :action => 'index')
    expire_page(:controller => 'sets', :action => 'show' ,:id => params[:id])

    success_redirect_to t('notice.set-delete-name'), :back
  end

  def destroy
    error_redirect_to t('notice.not-found'), sets_path and return if !set_exists? params[:id]

    set = Sets.find(params[:id])
    set.delete

    expire_page(:controller => 'sets', :action => 'index')

    success_redirect_to t('notice.set-delete'), :back
  end

  def select
    @idiom_id = params[:term_id]
    @sets = Sets.all

    error_redirect_to t('notice.not-found'), user_index_path and return if @idiom_id.nil?
    error_redirect_to t('notice.not-found'), user_index_path and return if @sets.empty?
  end

  def set_goal
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless language_is_valid? params[:language_id]

    if UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id]).empty?
      UserSets.create(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id], :chapter => 1)
    end

    success_redirect_to t('notice.user-add-goal'), set_path(params[:id]) and return if params[:redirect_to] == "sets"
    success_redirect_to t('notice.user-add-goal'), :back
  end

  def unset_goal
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless language_is_valid? params[:language_id]

    UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id]).each do |user_set|
      user_set.delete
    end

    success_redirect_to t('notice.user-remove-goal'), :back
  end

  def review
    error_redirect_to t('notice.not-found'), languages_path and return unless language_is_valid? params[:language_id]
    error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:id]

    review_types = parse_review_types params[:review_mode]
    error_redirect_to t('notice.review-mode-not-set'), language_set_path(params[:language_id], params[:id]) and return if review_types.empty?


    #get user set
    user_set = UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id])
    if user_set.empty?
      user_set = UserSets.create(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id], :chapter => 1)
    else
      user_set = user_set.first
    end


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? params[:language_id], params[:id]
      error_redirect_to t('notice.set-no-language-support'), language_set_path(params[:language_id], params[:id]) and return
    end


    #get next due card for user
    due_item = UserIdiomSchedule::get_next_due_for_user_for_set_for_proficiencies(params[:language_id], current_user.id, params[:id], review_types)
    unless due_item.nil?
      # do we need to create review_types for this card?
      review_types.each do |review_type|
        if UserIdiomDueItems.where(:user_idiom_schedule_id => due_item.user_idiom_schedule.id, :review_type => review_type).empty?
          UserIdiomDueItems.create(:user_idiom_schedule_id => due_item.user_idiom_schedule.id, :due => Time.now, :interval => CardTiming.get_first.seconds, :review_type => review_type)
        end
      end
      redirect_to review_language_set_term_path(params[:language_id], params[:id], due_item.user_idiom_schedule.idiom_id, :review_mode => params[:review_mode]) and return
    end


    #there are no due cards; can we schedule one?
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(params[:language_id], current_user.native_language_id, current_user.id, params[:id], review_types)
    if next_term.nil?
      redirect_to completed_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode]) and return
    end


    # is the next card in the next chapter? We should ask the user if they want to progress
    if next_term.chapter > user_set.chapter
      redirect_to next_chapter_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode]) and return
    else
      #show the new card to the user

      # only create a schedule if it does not exist; we can get to this place with migrated users
      scheduled_term = get_first UserIdiomSchedule.where(:user_id => current_user.id, :language_id => params[:language_id], :idiom_id => next_term.term_id)
      scheduled_term ||= UserIdiomSchedule.create(:user_id => current_user.id, :language_id => params[:language_id], :idiom_id => next_term.term_id)
      review_types.each do |review_type|
        if UserIdiomDueItems.where(:user_idiom_schedule_id => scheduled_term.id, :review_type => review_type).empty?
          UserIdiomDueItems.create(:user_idiom_schedule_id => scheduled_term.id, :due => Time.now, :interval => CardTiming.get_first.seconds, :review_type => review_type)
        end
      end
      redirect_to first_review_language_set_term_path(params[:language_id], params[:id], next_term.term_id, :review_mode => params[:review_mode]) and return
    end
  end

  def next_chapter
    redirect_target = is_user_at_end_of_chapter? current_user.id, params[:id], params[:language_id], params[:review_mode]
    redirect_to redirect_target and return unless redirect_target.nil?

    review_types = parse_review_types params[:review_mode]
    
    sql = <<-SQL
      select due_item.due
      from user_idiom_due_items due_item
      inner join user_idiom_schedules s
        on s.id = due_item.user_idiom_schedule_id
        and s.user_id = #{current_user.id}
        and s.language_id = #{params[:language_id]}
      inner join set_terms st
        on s.idiom_id = st.term_id
        and st.set_id = #{params[:id]}
      where due_item.review_type in (#{review_types.join(',')})
      order by due_item.due desc
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    as_time = results.first["due"]

    @next_due_time = Time.parse(as_time).utc + Time.parse(as_time).gmt_offset
    @refresh_in_ms = (@next_due_time - Time.now) * 1000
  end
  
  def completed
    error_redirect_to t('notice.not-found'), languages_path and return unless language_is_valid? params[:language_id]
    error_redirect_to t('notice.not-found'), language_path(params[:language_id]) and return unless set_exists? params[:id]

    review_types = parse_review_types params[:review_mode]
    return error_redirect_to t('notice.review-mode-not-set'), language_set_path(params[:language_id], params[:id]) if review_types.empty?

    
    #get user set
    user_set = UserSets.where(:user_id => current_user.id, :set_id => params[:id], :language_id => params[:language_id])
    if user_set.empty?
      return redirect_to language_sets_path(params[:language_id], params[:id])
    end
    user_set = user_set.first


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? params[:language_id], params[:id]
      error_redirect_to t('notice.set-no-language-support'), language_set_path(params[:language_id], params[:id]) and return
    end

    #are there are any due cards?
    next_due = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies params[:language_id], current_user.id, params[:id], review_types
    unless next_due.nil?
      return redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
    end


    #there are no due cards; can we schedule one?
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(params[:language_id], current_user.native_language_id, current_user.id, params[:id], review_types)
    #there are unscheduled cards; we should be on the chapter page or ready for review
    unless next_term.nil?
      return redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
    end


    #TODO: move somewhere testable
    sql = <<-SQL
      select due_item.due as due
      from user_idiom_due_items due_item
      inner join user_idiom_schedules s
        on s.id = due_item.user_idiom_schedule_id
        and s.user_id = #{current_user.id}
        and s.language_id = #{params[:language_id]}
      inner join set_terms st
        on s.idiom_id = st.term_id
        and st.set_id = #{params[:id]}
      where due_item.review_type in (#{review_types.join(',')})
      order by due_item.due desc
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    as_time = results.first["due"]

    @next_due_time = Time.parse(as_time).utc + Time.parse(as_time).gmt_offset
    @refresh_in_ms = (@next_due_time - Time.now) * 1000
  end

  def advance_chapter
    redirect_target = is_user_at_end_of_chapter? current_user.id, params[:id], params[:language_id], params[:review_mode]
    redirect_to redirect_target and return unless redirect_target.nil?

    #advance user chapter
    user_set = UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id])
    user_set = user_set.first
    user_set.chapter = user_set.chapter + 1
    user_set.save!
    
    redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
  end

  def due_count
    review_types = parse_review_types params[:review_mode]

    @due_count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(params[:language_id], current_user.id, params[:id], review_types)

    respond_to do |format|
      format.json { render :json => @due_count}
    end
  end

  def edit
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? params[:id]

    @set = Sets.find(params[:id])
    @set_names = SetName.order(:name).where(:sets_id => params[:id])

    error_redirect_to t('notice.not-found'), sets_path and return if @set_names.empty?
  end

  def update
    error_redirect_to t('notice.not-found'), sets_path and return if !set_exists? params[:id]

    @set = Sets.find(params[:id])
    @set_names = []
    valid_count = 0
    params[:set_name].each do |set_name|
      set_name = set_name.last
      existing_set = nil
      begin
        existing_set = SetName.find(set_name[:id])
      rescue
        existing_set = nil
      end


      if existing_set.nil?
        new_set_name = SetName.new(set_name)
        new_set_name.sets_id = params[:id]

        # do not save if one of the names are invalid (ignoring completely empty names)
        valid_count = valid_count + 1 if new_set_name.valid? or (new_set_name.name.blank? and new_set_name.description.blank?)
        @set_names << new_set_name
      else
        existing_set.update_attributes(set_name)

        valid_count = valid_count + 1 if existing_set.valid?
        @set_names << existing_set
      end
    end

    if valid_count == @set_names.count
      @set_names.each do |set_name|
        set_name.save
      end

      expire_page(:controller => 'sets', :action => 'index')
      expire_page(:controller => 'sets', :action => 'show' ,:id => params[:id])

      success_redirect_to t('notice.set-update'), set_path(params[:id])
    end
  end

  def save_chapter_order
    set_id = params[:id]
    error_redirect_to t('notice.not-found'), sets_path and return unless set_exists? set_id
    return redirect_to set_path(set_id) if params[:item].nil?

    
    lowest_position = nil
    changed_set_terms = []
    index = 0
    params[:item].each do |item|
      set_term = get_first SetTerms.where(:set_id => set_id, :term_id => item)
      next if set_term.nil?

      if lowest_position.nil? or lowest_position > set_term.position
        lowest_position = set_term.position
      end

      set_term.position = index

      changed_set_terms << set_term
      index += 1
    end

    changed_set_terms.each do |set_term|
      set_term.position += lowest_position
      set_term.save
    end

    Sets.find(set_id).remove_gaps_in_ordering

    redirect_to set_path(set_id)
  end
end
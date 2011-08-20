class SetsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @set_name = SetName.new
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

    redirect_to set_path(set.id)
  end

  def show
    redirect_to sets_path and return if !set_exists? params[:id]

    @set = Sets.find(params[:id])
    @set_names = SetName.order(:name).where(:sets_id => params[:id])
    redirect_to sets_path and return if @set_names.empty?

    @idiom_translations = []
    SetTerms.order(:chapter).order(:position).where(:set_id => params[:id]).each do |set|
      IdiomTranslation.joins(:translation).order(:language_id).order(:form).where(:idiom_id => set.term_id).each do |idiom_translation|
        idiom_translation[:chapter] = set.chapter
        idiom_translation[:position] = set.position
        @idiom_translations << idiom_translation
      end
    end

    @user_goal = UserSets.where(:set_id => @set.id, :user_id => current_user.id)
  end

  def index
    @sets = Sets.all
  end

  def edit
    redirect_to sets_path and return if !set_exists? params[:id]

    @set = Sets.find(params[:id])
    @set_names = SetName.order(:name).where(:sets_id => params[:id])
    
    redirect_to sets_path and return if @set_names.empty?
  end

  def update
    redirect_to sets_path and return if !set_exists? params[:id]

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

      redirect_to set_path(params[:id]) and return
    end
  end

  def add_set_name
    @set_name = SetName.new
    @i = params[:i]
  end

  def delete_set_name
    redirect_to sets_path and return if !set_exists? params[:id]
    redirect_to sets_path and return if !set_name_exists? params[:id], params[:set_name_id]
    if SetName.where(:sets_id => params[:id]).count == 1
      flash[:failure] = "Can't delete last set name"

      redirect_to :back
      return
    end

    set_name = SetName.find params[:set_name_id]
    set_name.delete

    redirect_to :back
  end

  def destroy
    redirect_to sets_path and return if !set_exists? params[:id]

    set = Sets.find(params[:id])
    set.delete

    redirect_to :back
  end

  def select
    @idiom_id = params[:term_id]
    @sets = Sets.all

    redirect_to user_index_path and return if @idiom_id.nil?
    redirect_to user_index_path and return if @sets.empty?
  end

  def set_goal
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to sets_path and return unless language_exists? params[:language_id]

    if UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id]).empty?
      UserSets.create(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id], :chapter => 1)
    end

    redirect_to set_path(params[:id]) and return if params[:redirect_to] == "sets"
    redirect_to :back
  end

  def unset_goal
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to sets_path and return unless language_exists? params[:language_id]

    UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id]).each do |user_set|
      user_set.delete
    end

    redirect_to :back
  end

  def review
    redirect_to languages_path and return unless language_exists? params[:language_id]
    redirect_to language_path(params[:language_id]) and return unless set_exists? params[:id]

    review_types = parse_review_types params[:review_mode]
    redirect_to language_set_path(params[:language_id], params[:id]) and return if review_types.empty?


    #get user set
    user_set = UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id])
    if user_set.empty?
      user_set = UserSets.create(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id], :chapter => 1)
    else
      user_set = user_set.first
    end


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? params[:language_id], params[:id]
      flash[:failure] = "This set can't be reviewed in the specified language because it has not been translated into that language"
      redirect_to language_set_path(params[:language_id], params[:id]) and return
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
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(params[:language_id], current_user.id, params[:id], review_types)
    if next_term.nil?
      redirect_to completed_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode]) and return
    end


    # is the next card in the next chapter? We should ask the user if they want to progress
    if next_term.chapter > user_set.chapter
      redirect_to next_chapter_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode]) and return
    else
      #show the card to the user
      scheduled_term = UserIdiomSchedule.create(:user_id => current_user.id, :language_id => params[:language_id], :idiom_id => next_term.term_id)
      review_types.each do |review_type|
        if UserIdiomDueItems.where(:user_idiom_schedule_id => scheduled_term.id, :review_type => review_type).empty?
          UserIdiomDueItems.create(:user_idiom_schedule_id => scheduled_term.id, :due => Time.now, :interval => CardTiming.get_first.seconds, :review_type => review_type)
        end
      end
      redirect_to review_language_set_term_path(params[:language_id], params[:id], next_term.term_id, :review_mode => params[:review_mode]) and return
    end
  end

  def next_chapter
    redirect_target = is_user_at_end_of_chapter current_user.id, params[:id], params[:language_id], params[:review_mode]
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
    redirect_to languages_path and return unless language_exists? params[:language_id]
    redirect_to language_path(params[:language_id]) and return unless set_exists? params[:id]

    review_types = parse_review_types params[:review_mode]
    if review_types.empty?
      return redirect_to language_set_path(params[:language_id], params[:id])
    end

    #get user set
    user_set = UserSets.where(:user_id => current_user.id, :set_id => params[:id], :language_id => params[:language_id])
    if user_set.empty?
      return redirect_to language_sets_path(params[:language_id], params[:id])
    end
    user_set = user_set.first


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? params[:language_id], params[:id]
      flash[:failure] = "This set can't be reviewed in the specified language because it has not been translated into that language"
      redirect_to language_set_path(params[:language_id], params[:id]) and return
    end

    #are there are any due cards?
    next_due = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies params[:language_id], current_user.id, params[:id], review_types
    unless next_due.nil?
      return redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
    end


    #there are no due cards; can we schedule one?
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(params[:language_id], current_user.id, params[:id], review_types)
    #there are unscheduled cards; we should be on the chapter page or ready for review
    unless next_term.nil?
      return redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
    end


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

  def advance_chapter
    redirect_target = is_user_at_end_of_chapter current_user.id, params[:id], params[:language_id], params[:review_mode]
    redirect_to redirect_target and return unless redirect_target.nil?

    #advance user chapter
    user_set = UserSets.where(:set_id => params[:id], :user_id => current_user.id, :language_id => params[:language_id])
    user_set = user_set.first
    user_set.chapter = user_set.chapter + 1
    user_set.save!
    
    redirect_to review_language_set_path(params[:language_id], params[:id], :review_mode => params[:review_mode])
  end

  private
  def is_user_at_end_of_chapter user_id, set_id, language_id, review_mode
    return languages_path unless language_exists? language_id
    return language_path(language_id) unless set_exists? set_id

    review_types = parse_review_types review_mode
    if review_types.empty?
      return language_set_path(language_id, set_id)
    end

    #get user set
    user_set = UserSets.where(:user_id => user_id, :set_id => set_id, :language_id => language_id)
    if user_set.empty?
      return language_sets_path(language_id, set_id)
    end
    user_set = user_set.first


    #are there cards in the set for the language?
    unless set_has_at_least_one_idiom_for_language? language_id, set_id
      flash[:failure] = "This set can't be reviewed in the specified language because it has not been translated into that language"
      return language_set_path(language_id, set_id)
    end


    #are there are any due cards?
    next_due = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies language_id, user_id, set_id, review_types
    unless next_due.nil?
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end


    #there are no due cards; can we schedule one?
    next_term = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies(language_id, user_id, set_id, review_types)
    #there are no cards left at all; we should go to the completed page
    if next_term.nil?
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end

    #redirect if we have to schedule in this chapter
    unless next_term.chapter > user_set.chapter
      return review_language_set_path(language_id, set_id, :review_mode => review_mode)
    end

    return nil
  end

  #TODO: move to domain specific helpers
  def set_has_at_least_one_idiom_for_language? language_id, set_id
    language_id = language_id.to_i
    set_id = set_id.to_i

    SetTerms.where(:set_id => set_id).each do |set_terms|
      IdiomTranslation.joins(:translation).where(:idiom_id => set_terms.term_id).each do |idiom_translation|
        begin
          language = Language.find(idiom_translation.translation.language_id)
        rescue
          next
        end

        if language.id == language_id
          return true
        end
      end
    end

    false
  end

  def set_exists? set_id
    begin
      Sets.find(set_id)
      true
    rescue
      false
    end
  end

  def set_name_exists? set_id, set_name_id
    begin
      # set name exists
      set_name = SetName.find(set_name_id)

      # and set name belongs to set
      return set_name.sets_id == set_id.to_i
    rescue
      false
    end
  end

  def idiom_exists? idiom_id
    begin
      Idiom.find(idiom_id)
      true
    rescue
      false
    end
  end

  def language_exists? id
    begin
      Language.find(id)
      true
    rescue
      false
    end
  end

  def parse_review_types review_types
    return [] if review_types.nil?
    
    review_type_nums = []
    review_types.split(',').each do |review_type|
      review_type.strip!

      value = UserIdiomReview.to_review_type_int(review_type)
      review_type_nums << value unless value.nil?
    end

    return review_type_nums
  end
end

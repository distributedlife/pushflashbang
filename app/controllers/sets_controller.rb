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
      IdiomTranslation.joins(:translation).order(:language).order(:form).where(:idiom_id => set.term_id).each do |idiom_translation|
        idiom_translation[:chapter] = set.chapter
        idiom_translation[:position] = set.position
        @idiom_translations << idiom_translation
      end
    end
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
    @idiom_id = params[:idiom_id]
    @sets = Sets.all

    redirect_to user_index_path and return if @idiom_id.nil?
    redirect_to user_index_path and return if @sets.empty?
  end

  def add_term
    redirect_to user_index_path and return unless set_exists? params[:id]
    redirect_to user_index_path and return unless idiom_exists? params[:idiom_id]

    if (SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id]).empty?)
      max_position = SetTerms.where(:set_id => params[:id]).maximum(:position)
      max_position ||= 0

      SetTerms.create(:set_id => params[:id], :term_id => params[:idiom_id], :chapter => 1, :position => max_position + 1)
    end

    redirect_to set_path(params[:id])
  end

  def remove_term
    redirect_to user_index_path and return unless set_exists? params[:id]
    redirect_to user_index_path and return unless idiom_exists? params[:idiom_id]
    
    SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id]).each do |set_term|
      set_term.delete
    end

    redirect_to set_path(params[:id])
  end

  def term_next_chapter
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to set_path(params[:id]) and return unless idiom_exists? params[:idiom_id]
    
    set_term = SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id])
    redirect_to set_path(params[:id]) and return if set_term.empty?

    existing_chapter = set_term.first.chapter
    set_term.first.chapter = set_term.first.chapter + 1
    set_term.first.save

    if SetTerms.where(:set_id => params[:id], :chapter => existing_chapter).empty?
      SetTerms::decrement_chapters_for_set_after_chapter params[:id], existing_chapter
    end

    redirect_to set_path(params[:id])
  end

  def term_prev_chapter
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to set_path(params[:id]) and return unless idiom_exists? params[:idiom_id]

    set_term = SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id])
    redirect_to set_path(params[:id]) and return if set_term.empty?

    set_term.first.chapter = set_term.first.chapter - 1
    set_term.first.save
    
    if set_term.first.chapter == 0
      SetTerms::increment_chapters_for_set params[:id]
    end

    redirect_to set_path(params[:id])
  end

  def term_next_position
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to set_path(params[:id]) and return unless idiom_exists? params[:idiom_id]

    set_term = SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id])
    redirect_to set_path(params[:id]) and return if set_term.empty?


    current_position = set_term.first.position
    next_term = SetTerms.where(:set_id => params[:id], :chapter => set_term.first.chapter, :position => current_position + 1)

    unless next_term.empty?
      set_term.first.position = set_term.first.position + 1
      next_term.first.position = next_term.first.position - 1

      set_term.first.save
      next_term.first.save
    end

    redirect_to set_path(params[:id])
  end

  def term_prev_position
    redirect_to sets_path and return unless set_exists? params[:id]
    redirect_to set_path(params[:id]) and return unless idiom_exists? params[:idiom_id]

    set_term = SetTerms.where(:set_id => params[:id], :term_id => params[:idiom_id])
    redirect_to set_path(params[:id]) and return if set_term.empty?


    current_position = set_term.first.position
    prev_term = SetTerms.where(:set_id => params[:id], :chapter => set_term.first.chapter, :position => current_position - 1)

    unless prev_term.empty?
      set_term.first.position = set_term.first.position - 1
      prev_term.first.position = prev_term.first.position + 1

      set_term.first.save
      prev_term.first.save
    end

    redirect_to set_path(params[:id])
  end

  def make_goal
    redirect_to sets_path and return unless set_exists? params[:id]

    if UserSets.where(:set_id => params[:id], :user_id => current_user.id).empty?
      UserSets.create(:set_id => params[:id], :user_id => current_user.id, :chapter => 1)
    end

    redirect_to :back
  end

  private
  #TODO: move to domain specific helpers
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
end

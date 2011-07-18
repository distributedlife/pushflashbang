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
    redirect_to sets_path and return if !set_exists?
    
    @set_names = SetName.order(:name).where(:sets_id => params[:id])
    redirect_to sets_path and return if @set_names.empty?
  end

  def index
    @sets = Sets.joins(:set_name).order(:name)
    redirect_to user_index_path and return if @sets.empty?
  end

  def edit
    redirect_to sets_path and return if !set_exists?

    @set_names = SetName.order(:name).where(:sets_id => params[:id])
    redirect_to sets_path and return if @set_names.empty?
  end

  def update
    redirect_to sets_path and return if !set_exists?
ap params[:sets]
    @set_names = []
    valid_count = 0
    params[:sets].each do |set_name|
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

        valid_count = valid_count + 1 if new_set_name.valid?
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

  private
  def set_exists?
    begin
      Sets.find(params[:id])
      true
    rescue
      false
    end
  end
end

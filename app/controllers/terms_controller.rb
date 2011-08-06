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

      link = self.class.helpers.link_to('Click here to view.', edit_term_path(idiom.id))
      flash[:success] = "Related terms created. #{link}"
      redirect_to new_term_path and return
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
    redirect_to sets_path and return unless set_exists? params[:set_id]

    @translations = []
    all_translations_sorted_correctly.each do |translation|
      next if SetTerms.where(:set_id => params[:set_id], :term_id => translation.idiom_translations.idiom_id).count > 0

      @translations << translation
    end
  end

  def review
    begin
#      return redirect_to terms_path unless idiom_exists? params[:idiom_id]
#      ap params[:language_id]
#      ap params[:set_id]
#      ap params[:id]
      @term = Idiom.find(params[:id])

#      @deck = Deck.find(params[:deck_id])
#      @card = Card.find(params[:id])

      #create a scheduled card entry if one does not exist
#      scheduled_card = UserCardSchedule::where(:user_id => current_user.id, :card_id => params[:id])
#      if scheduled_card.empty?
#        scheduled_card = UserCardSchedule.create(:user_id => current_user.id, :card_id => params[:id], :due => Time.now, :interval => 0)
#      end

      if detect_browser == "mobile_application"
        render "learn.mobile"
      end
    rescue
    end
  end
  
  private
  def all_translations_sorted_correctly
    Translation.joins(:languages, :idiom_translations).order(:idiom_id).order(:name).order(:form).all
  end

  def get_idiom_translations
    if idiom_exists? params[:id]
      @translations = Translation.joins(:languages, :idiom_translations).order(:name).order(:form).where(:idiom_translations => {:idiom_id => params[:id]})

      if @translations.empty?
        flash[:failure] = "The term you were looking has no translations"
        redirect_to terms_path
      end
    else
      flash[:failure] = "The term you were looking for no longer exists"
      redirect_to terms_path
    end
  end

  def set_exists? id
    begin
      Sets.find(id)

      true
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

  def translation_exists? translation_id
    begin
      Translation.find(translation_id)

      true
    rescue
      false
    end
  end
end

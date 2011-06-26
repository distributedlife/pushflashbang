class TermsController < ApplicationController
  before_filter :authenticate_user!

  caches_page :index

  def index
    @translations = Translation.order(:idiom_id).order(:language).order(:form).all
  end
end

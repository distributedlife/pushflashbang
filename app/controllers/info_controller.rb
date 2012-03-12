# -*- encoding : utf-8 -*-
include RedirectHelper

class InfoController < ApplicationController
  def check_style
    error "Error flash level"
    info "Some informaton"
    warning "Some warning"
    success "Some success"
  end

  def about
    redirect_to user_index_path unless current_user.nil?
    @languages = Language.only_enabled
  end
end

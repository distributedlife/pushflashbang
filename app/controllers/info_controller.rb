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
  end

  def rebuild_relationships
    set = Sets.find(1)
    set.rebuild_all_relationships
  end
end

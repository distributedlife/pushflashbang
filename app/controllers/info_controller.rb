class InfoController < ApplicationController
  def check_style
    flash[:error] = "Error flash level"
    flash[:info] = "Some informaton"
  end

  def about
    redirect_to user_index_path unless current_user.nil?
  end

  def rebuild_relationships
    set = Sets.find(1)
    set.rebuild_all_relationships
  end
end

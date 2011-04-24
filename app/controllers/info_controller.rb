class InfoController < ApplicationController
  def check_style
    flash[:error] = "Error flash level"
    flash[:info] = "Some informaton"
  end

  def about
    
  end
end

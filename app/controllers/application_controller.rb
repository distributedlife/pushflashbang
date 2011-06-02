class ApplicationController < ActionController::Base
#  helper :all
  protect_from_forgery
  layout :detect_browser

  private
  MOBILE_BROWSERS = ['android']

  def after_sign_in_path_for(resource_or_scope)
    user_index_path
  end

  def detect_browser
    layout = selected_layout
    return layout if layout

    agent = request.headers["HTTP_USER_AGENT"].downcase

    MOBILE_BROWSERS.each do |m|
      return 'mobile_application' if agent.match(m)
    end

    return 'application'
#    return 'mobile_application'
  end

  def selected_layout
    session.inspect # force session load
    if session.has_key? "layout"
      return (session["layout"] == "mobile") ? "mobile_application" : "application"
    end

    return nil
  end
end

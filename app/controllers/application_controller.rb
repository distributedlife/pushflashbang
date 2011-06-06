class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :detect_browser

  private
  MOBILE_BROWSERS =
  [
    'android', "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;",
    "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2",
    "pocket","kindle", "mobile","pda","psp","treo"
  ]

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
  end

  def selected_layout
    session.inspect # force session load
    if session.has_key? "layout"
      return (session["layout"] == "mobile") ? "mobile_application" : "application"
    end

    return nil
  end
end

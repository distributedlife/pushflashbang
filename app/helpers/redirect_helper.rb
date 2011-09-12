module RedirectHelper
  def log message
    puts "User (#{current_user.email}) redirected: #{message}"
  end

  def warning message
    session[:warning] = message
    log "WARNING: #{message}"
  end

  def error message
    session[:error] = message
    log "ERROR: #{message}"
  end

  def success message
    session[:success] = message
    log "SUCCESS: #{message}"
  end

  def info message
    session[:info] = message
    log "INFO: #{message}"
  end

  def no_user_errors?
    return session[:error].nil?
  end

  def error_redirect_to(message, options = {}, response_status = {})
    error message
    
    redirect_to options, response_status
  end

  def warning_redirect_to(message, options = {}, response_status = {})
    warning message

    redirect_to options, response_status
  end

  def success_redirect_to(message, options = {}, response_status = {})
    success message

    redirect_to options, response_status
  end

  def info_redirect_to(message, options = {}, response_status = {})
    info message

    redirect_to options, response_status
  end
end
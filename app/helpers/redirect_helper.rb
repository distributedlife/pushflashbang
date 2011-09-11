module RedirectHelper
  def error_redirect_to(reason, options = {}, response_status = {})
    puts "User (#{current_user.id}) redirected: #{reason}"

    redirect_to options, response_status
  end
end
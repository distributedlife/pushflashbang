module EditAccountPage
  def url *params
    "/users/edit"
  end

  def is_current_page?
    @session.has_content?("Manage your account")
  end

  def cancel_account
    @session.click_on "cancel my account"
  end

  def change_email_address email
    @session.fill_in('user_email', :with => email)
    @session.fill_in('user_current_password', :with => @current_password)

    self.do_update
  end

  def change_password password
    @session.fill_in('user_password', :with => password)
    @session.fill_in('user_password_confirmation', :with => password)
    @session.fill_in('user_current_password', :with => @current_password)

    self.do_update
  end

  def email=

  end

  def current_password=

  end

  def new_password=

  end

  def new_password_confirm=

  end

  def do_update
    @session.click_on "make changes"
  end
end

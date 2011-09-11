module EditAccountPage
  def is_get?
    true
  end
  
  def url sut
    "/users/edit"
  end

  def is_current_page?
    @session.has_content?("Manage your account")
  end

  def cancel_account
    @session.click_on "cancel_account"
  end

  def change_email_address email, password
    @session.fill_in('user_email', :with => email)
    @session.fill_in('user_current_password', :with => password)

    self.do_update
  end

  def change_password old_password, new_password
    @session.fill_in('user_password', :with => new_password)
    @session.fill_in('user_password_confirmation', :with => new_password)
    @session.fill_in('user_current_password', :with => old_password)

    self.do_update
  end

  def do_update
    @session.click_on "update_account"
  end
end

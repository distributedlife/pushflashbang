module RegisterAccountPage
  def is_get?
    true
  end

  def url sut
    '/users/sign_up'
  end

  def is_current_page?
    @session.has_content?("Sign up").should == true
    @session.has_content?("email").should == true
    @session.has_content?("password").should == true
  end
end

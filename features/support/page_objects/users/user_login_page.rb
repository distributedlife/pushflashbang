module UserLoginPage
  def is_get?
    true
  end

  def url sut
    '/users/sign_in'
  end

  def is_current_page?
    @session.has_content?("Sign in").should == true
    @session.has_content?("email").should == true
    @session.has_content?("password").should == true
  end
end

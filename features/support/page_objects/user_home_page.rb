module UserHomePage
  def is_get?
    true
  end

  def url *params
    "/users"
  end

  def is_current_page?
    @session.has_content?("Welcome")
  end
end

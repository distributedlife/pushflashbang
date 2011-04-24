module TestWorld
  def on_page page_name, session
    page = BasePage.new session
    page.extend Object.const_get page_name

    yield page if block_given?

    page
  end

  def goto_page page_name, session, *params
#    self.start unless @session

    page = on_page page_name, session

    session.visit page.url *params

    yield page if block_given?

    page
  end

  def current_username= username
    @current_username = username
  end

  def current_username
    @current_username
  end

  def current_passsword= password
    @current_password = password
  end

  def current_password
    @current_password
  end
end
World(TestWorld)
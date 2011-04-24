class BasePage
  def initialize session
    @session = session
  end

  def visit
    @session.visit url
  end

  def is_current_page?
    raise "You haven't implemented a quick check to make sure you are on the page you think you are"
  end

  def url *params
    raise "you haven't declared a url here"
  end
end
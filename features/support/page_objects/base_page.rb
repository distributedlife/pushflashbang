class BasePage
  def initialize session
    @session = session
  end

  def visit sut
    if is_get?
      @session.visit url sut
    else
      navigate_to
    end
  end

  def is_current_page?
    raise "You haven't implemented a quick check to make sure you are on the page you think you are"
  end

  def url sut
    raise "you haven't declared a url here"
  end

  def is_get?
    raise "you haven't said if this page is a GET request"
  end

  def navigate_to
    raise "you haven't implemented this yet"
  end
end
module TestWorld
  def on_page page_name, session
    page = BasePage.new session
    page.extend Object.const_get page_name

    yield page if block_given?

    page
  end

  def goto_page page_name, session, sut
    page = on_page page_name, session
    page.visit sut

    yield page if block_given?

    page
  end
end
World(TestWorld)
module NextSetChapterPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/next_chapter?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "You've reached chapter"
  end

  def advance!
    @session.click_on "do_advance"
  end
end

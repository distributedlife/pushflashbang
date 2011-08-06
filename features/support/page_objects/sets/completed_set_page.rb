module CompletedSetPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/complete?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "Set Complete!"
  end
end

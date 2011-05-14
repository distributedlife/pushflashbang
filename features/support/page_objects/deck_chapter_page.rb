module DeckChapterPage
  def is_get?
    true
  end

  def url id
    "/deck/#{id}/chapter"
  end

  def is_current_page?
    @session.has_content?("Advance")
  end
end

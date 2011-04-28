module DeckSessionPage
  def is_get?
    true
  end

  def url deck_id
    "/deck/#{deck_id}/learn"
  end

  def is_current_page?
    @session.has_content? "Card Review"
  end
end

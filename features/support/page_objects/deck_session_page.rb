module DeckSessionPage
  def is_get?
    true
  end

  def url deck_id
    "/deck/#{deck_id}/learn"
  end

  def is_current_page?
    raise "you need to put a simply check in here"
  end
end

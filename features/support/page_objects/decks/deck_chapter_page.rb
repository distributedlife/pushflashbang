# -*- encoding : utf-8 -*-
module DeckChapterPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}/chapters/#{sut.get(:chapter)}"
  end

  def is_current_page?
    @session.has_content?("Advance")
  end
end

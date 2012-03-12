# -*- encoding : utf-8 -*-
module ReviewSetPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/review?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "Card Review"
  end
end

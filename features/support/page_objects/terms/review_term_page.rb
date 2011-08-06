module ReviewTermPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/terms/#{sut.get(:idiom).id}/review?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "Review"
  end

  def is_term term_id
    @session.find("#term_#{term_id}")
  end
end

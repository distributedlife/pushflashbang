module ShowDeckPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}"
  end

  def is_current_page?
    @session.has_content?("Review").should == true
  end
end

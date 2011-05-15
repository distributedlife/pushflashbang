module ShowCardPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}/card/#{sut.get(:card_id)}"
  end

  def is_current_page?
    @session.has_content?("Card Details").should == true
  end
end

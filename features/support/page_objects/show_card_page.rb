module ShowCardPage
  def is_get?
    true
  end

  def url *params
    "/deck/#{params[0][0][0][:deck_id]}/card/#{params[0][0][0][:id]}"
  end

  def is_current_page?
    @session.has_content?("Card Details").should == true
  end
end

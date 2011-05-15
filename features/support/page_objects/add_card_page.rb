module AddCardPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}/card/new"
  end

  def is_current_page?
    @session.has_content?("Add Card").should == true
  end

  def front= value
    @session.fill_in('card_front', :with => value)
  end

  def back= value
    @session.fill_in('card_back', :with => value)
  end

  def pronunciation= value
    @session.fill_in('card_pronunciation', :with => value)
  end

  def chapter= value
    @session.fill_in('card_chapter', :with => value)
  end

  def add_card
    @session.click_on('Add')
  end

  def front
    @session.find_field('card_front').value
  end

  def back
    @session.find_field('card_back').value
  end

  def pronunciation
    @session.find_field('card_pronunciation').value
  end
end

# -*- encoding : utf-8 -*-
module EditDeckPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}/edit"
  end

  def is_current_page?
    @session.has_content?("Edit Deck").should == true
  end

  def name= value
    @session.fill_in('deck_name', :with => value)
  end

  def description= value
    @session.fill_in('deck_description', :with => value)
  end
end

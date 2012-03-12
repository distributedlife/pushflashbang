# -*- encoding : utf-8 -*-
module DeckSessionPage
  def is_get?
    true
  end

  def url sut
    "/deck/#{sut.get(:deck_id)}/learn"
  end

  def is_current_page?
    @session.has_content? "Card Review"
  end

  def input_field_exists?
    @session.find_field('card_front').nil? == false
  end

  def type_answer answer
    @session.fill_in('card_front', :with => answer)
  end
end

Given /^I am logged in and have created a deck$/ do
  Given %{I am a new, authenticated user}
  And %{I have created a deck}
end

Then /^I should be on the add card page$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^I am on the add card page$/ do
  goto_page :AddCardPage, Capybara.current_session, @current_deck.id do |page|
  end
end

When /^I create a card$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front = "The front of the card"
    page.back = "The back of the card"
    page.add_card
  end

  @current_card = Card.last
end

Then /^I am redirected to the add card page$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Then /^the form is empty$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front.should == ""
    page.back.should == ""
  end
end

Given /^I have created a card$/ do
  @current_card = Card.make(:deck_id => @current_deck.id, :front => "front of my card", :back => "back of my card")
end

Then /^I can see all cards in this deck$/ do
  cards_in_deck = Card.where(:deck_id => @current_deck.id)
  cards_in_deck.each do |card|
    Then %{I should see "#{card.front}"}
  end
end

When /^I create a card without a front$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front = ""
    page.back = "The back of the card"
    page.add_card
  end
end

Then /^I should be on the edit card page$/ do
  on_page :EditCardPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^I am on the show card page$/ do
  goto_page :ShowCardPage, Capybara.current_session, {:deck_id => @current_deck.id, :id => @current_card.id} do |page|
  end
end

Given /^I am on the edit card page$/ do
  goto_page :EditCardPage, Capybara.current_session, {:deck_id => @current_deck.id, :id => @current_card.id} do |page|
  end
end

When /^I change all deck properties$/ do
  on_page :EditCardPage, Capybara.current_session do |page|
    page.front = "This is really fun"
    page.back = "This is less fun"
  end
end

Then /^I should be on the show card page$/ do
  on_page :ShowCardPage, Capybara.current_session do |page|
    page.is_current_page?
  end
end

Then /^I can see the card changes$/ do
  on_page :ShowCardPage, Capybara.current_session do |page|
    And %{I should see "This is really fun"}
    And %{I should see "This is less fun"}
  end
end

Then /^the card should be deleted$/ do
  lambda {Card.find(@current_card.id)}.should raise_exception
end

Then /^I should be on the show deck page$/ do
  on_page :ShowDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^I have created multiple cards$/ do
  card1 = Card.make(:deck_id => @current_deck.id, :front => "front of my card", :back => "back of my card")
  card2 = Card.make(:deck_id => @current_deck.id, :front => "the quick brown fox jumps over the lazy dog", :back => "the time has come for all good men to attend the dance")

  @current_card = card2
end

Then /^I should see all cards in the deck$/ do
  Card.all.each do |card|
    And %{I should see "#{card.front}"}
  end
end

Then /^I should see the pronunciation$/ do
  And %{I should see "#{@first_due_card.pronunciation}"}
end

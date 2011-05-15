And /^I am logged in and have created a deck$/ do
  And %{I am a new, authenticated user}
  And %{I have created a deck}
end

And /^I have created multiple cards$/ do
  add(:card, Card.make(:deck_id => get(:deck_id), :front => "front of my card", :back => "back of my card"))
  add(:card_id, get(:card).id)
  add(:card, Card.make(:deck_id => get(:deck_id), :front => "the quick brown fox jumps over the lazy dog", :back => "the time has come for all good men to attend the dance"))
  add(:card_id, get(:card).id)
end

And /^I create a card$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front = "The front of the card"
    page.back = "The back of the card"
    page.pronunciation = "wrrgrbl"
    page.chapter = 1
    page.add_card
  end

  add(:card, Card.last)
  add(:card_id, get(:card).id)
end

And /^I have created a card$/ do
  add(:card, Card.make(:deck_id => get(:deck_id), :front => "front of my card", :back => "back of my card"))
  add(:card_id, get(:card).id)
end

And /^I create a card without a front$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front = ""
    page.back = "The back of the card"
    page.chapter = 1
    page.add_card
  end
end

And /^the card interval is (\d+)$/ do |interval|
  card_schedule = UserCardSchedule::get_next_due_for_user_for_deck(get(:user_id), get(:deck_id))

  card_schedule.interval = interval
  card_schedule.save!
end

And /^I change all deck properties$/ do
  add(:original_card, get(:card).clone)

  on_page :EditCardPage, Capybara.current_session do |page|
    page.front = "This is really fun"
    page.back = "This is less fun"
    page.pronunciation = "cheese"
  end
end

And /^the form is empty$/ do
  on_page :AddCardPage, Capybara.current_session do |page|
    page.front.should == ""
    page.back.should == ""
    page.pronunciation.should == ""
  end
end

And /^I can see all cards in this deck$/ do
  Card.where(:deck_id => get(:deck_id)).each do |card|
    Then %{I should see "#{card.front}"}
  end
end

And /^I can see the card changes$/ do
  get(:card).reload

  on_page :ShowCardPage, Capybara.current_session do |page|
    And %{I should not see "#{get(:original_card).front}"}
    And %{I should not see "#{get(:original_card).back}"}
    And %{I should not see "#{get(:original_card).pronunciation}"}
    And %{I should see "#{get(:card).front}"}
    And %{I should see "#{get(:card).back}"}
    And %{I should see "#{get(:card).pronunciation}"}
  end
end

And /^the card should be deleted$/ do
  lambda {Card.find(get(:card_id))}.should raise_exception
end

And /^I should see all cards in the deck$/ do
  Card.where(:deck_id => get(:deck_id)).each do |card|
    And %{I should see "#{card.front}"}
  end
end

And /^I should see the pronunciation$/ do
  And %{I should see "#{get(:card).pronunciation}"}
end

And /^I create a deck$/ do
  on_page :CreateDeckPage, Capybara.current_session do |page|
    page.create_deck "my deck", "this is my deck of stuff to learn"
  end

  add(:deck, Deck.last)
  add(:deck_id, get(:deck).id)
end

And /^a deck created by another user$/ do
  another_user = User.make

  add(:deck, Deck.make(:name => "SimpleDeck", :user_id => another_user.id))
  add(:deck_id, get(:deck).id)
end

And /^the deck is shared$/ do
  deck = get(:deck)
  deck.shared = true
  deck.save!
end

And /^the deck is configured for typed answers$/ do
  deck = get(:deck)
  deck.supports_written_answer = true
  deck.save!
end

And /^the deck is configured to show the pronunciation on the front$/ do
  deck = get(:deck)
  deck.pronunciation_side = 'front'
  deck.save!
end

And /^the deck is configured to show the pronunciation on the back$/ do
  deck = get(:deck)
  deck.pronunciation_side = 'back'
  deck.save!
end

And /^I have created a deck$/ do
  add(:deck, Deck.make(:name => "My Deck", :user_id => get(:user_id)))
  add(:deck_id, get(:deck).id)
end

And /^I have created many cards in the deck$/ do
  5.times do
    card = Card.make(:deck_id => get(:deck_id))

    add(:card, card)
    add(:card_id, card.id)
  end
end

And /^I have a deck with (\d+) chapters$/ do |chapter_count|
  deck = Deck.make(:name => "My Deck", :user_id => get(:user_id))
  add(:deck, deck)
  add(:deck_id, deck.id)

  chapter_count.to_i.times do |i|
    Card.make(:deck_id => deck.id, :chapter => i + 1)
  end
end

And /^I edit all deck properties$/ do
  add(:original_deck, get(:deck).clone)

  new_name = "Edit deck name"
  new_description = "Edit deck description"

  on_page :EditDeckPage, Capybara.current_session do |page|
    page.name = new_name
    page.description = new_description
  end  
end

And /^I edit all deck properties to be invalid$/ do
  add(:edited_deck_name, "")
  add(:edited_deck_description, "X" * 501)

  on_page :EditDeckPage, Capybara.current_session do |page|
    page.name = get(:edited_deck_name)
    page.description = get(:edited_deck_description)
  end
end

And /^the deck should be updated$/ do
  get(:deck).reload
  
  on_page :ShowDeckPage, Capybara.current_session do |page|
    And %{I should not see "#{get(:original_deck).name}"}
    And %{I should not see "#{get(:original_deck).description}"}
    And %{I should see "#{get(:deck).name}"}
    And %{I should see "#{get(:deck).description}"}
  end
end

And /^the deck is not updated$/ do
  get(:deck).reload

  on_page :ShowDeckPage, Capybara.current_session do |page|
    And %{I should not see "#{get(:deck).name}"}
    And %{I should not see "#{get(:deck).description}"}
    And %{I should see "#{get(:edited_deck_name)}"}
    And %{I should see "#{get(:edited_deck_description)}"}
  end
end

And /^the deck should be deleted$/ do
  lambda {Deck.find(get(:deck_id))}.should raise_exception
end

And /^I can see all of my decks$/ do
  decks = Deck.where(:user_id => get(:user_id))

  decks.each do |deck|
    And %{I should see "#{deck.name}"}
    And %{I should see "#{deck.description}"}
    And %{I should see "#{deck.pronunciation_side}"}
  end
end

And /^I will not see decks created by other users$/ do
  decks = Deck.all

  decks.each do |deck|
    if deck.user_id != get(:user_id)
      And %{I should not see "#{deck.name}"}

      unless deck.description.nil?
        And %{I should not see "#{deck.description}"}
      end
    end
  end
end

And /^I will see shared decks created by other users$/ do
  decks = Deck.all

  decks.each do |deck|
    if deck.user_id != get(:user_id)
      if deck.shared == true
        And %{I should see "#{deck.name}"}
        And %{I should see "#{deck.pronunciation_side}"}

        unless deck.description.nil?
          And %{I should see "#{deck.description}"}
        end
      else
        And %{I should not see "#{deck.name}"}
        And %{I should not see "#{deck.pronunciation_side}"}

        unless deck.description.nil?
          And %{I should not see "#{deck.description}"}
        end
      end
    end
  end

  Deck.where(:shared => true).count.should >= 1
end

And /^the deck should be shared$/ do
  get(:deck).reload
  get(:deck).shared.should == true
end

Then /^the deck should not be shared$/ do
  get(:deck).reload
  get(:deck).shared.should == false
end

And /^I should see the card count$/ do
  And %{I should see "#{Card.where(:deck_id => get(:deck_id)).count}"}
end

And /^I should see the card due count$/ do
  And %{I should see "#{UserCardSchedule.get_due_count_for_user_for_deck(get(:user_id), get(:deck_id))}"}
end

And /^I should see an input field to type my answer$/ do
  on_page :DeckSessionPage, Capybara.current_session do |page|
    page.input_field_exists?.should == true
  end
end

And /^I type the answer correctly$/ do
  ap get(:card).front
  on_page :DeckSessionPage, Capybara.current_session do |page|
    page.type_answer get(:card).front
  end
end

And /^I type the answer incorrectly$/ do
  on_page :DeckSessionPage, Capybara.current_session do |page|
    page.type_answer "zz#{get(:card).front}zz"
  end
end

And /^I should see my answer was correct$/ do
  And %{I should see "is correct"}
end

And /^I should see my answer was incorrect$/ do
  And %{I should see "is not correct"}
end
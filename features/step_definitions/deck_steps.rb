Given /^I am on the create deck page$/ do
  goto_page :CreateDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

When /^I create a deck$/ do
  on_page :CreateDeckPage, Capybara.current_session do |page|
    page.create_deck "my deck", "this is my deck of stuff to learn"#, "en", "au"
  end
end

Then /^I should be redirected to the show deck page$/ do
  on_page :ShowDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Then /^I should be redirected to the user home page$/ do
  on_page :UserHomePage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^a deck created by another user$/ do
  another_user = User.make
  @current_deck = Deck.make(:name => "SimpleDeck", :user_id => another_user.id)
end

When /^I go to the show deck page$/ do
  goto_page :ShowDeckPage, Capybara.current_session, @current_deck.id do |page|
  end
end

Given /^I am on the show deck page$/ do
  goto_page :ShowDeckPage, Capybara.current_session, @current_deck.id do |page|
  end
end


Given /^I have created a deck$/ do
  @current_deck = Deck.make(:name => "My Deck", :user_id => @current_user.first.id)
end

Given /^I have a deck where the pronunciation is shown on front$/ do
  @current_deck = Deck.make(:name => "My Deck", :user_id => @current_user.first.id, :pronunciation_side => 'front')
end

Given /^I have a deck where the pronunciation is shown on back$/ do
  @current_deck = Deck.make(:name => "My Deck", :user_id => @current_user.first.id, :pronunciation_side => 'back')
end



Given /^I am on the edit deck page$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
    page.is_current_page?.should == true
  end
end

Given /^I edit all deck properties$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
    page.name = "Edit deck name"
    page.description = "Edit deck description"
  end
end

Then /^I am redirected to the show deck page$/ do
  on_page :ShowDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Then /^the deck should be updated$/ do
  on_page :ShowDeckPage, Capybara.current_session do |page|
    And %{I should see "Edit deck name"}
    And %{I should see "Edit deck description"}
  end
end

Given /^I edit all deck properties to be invalid$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
    page.name = ""
    page.description = "X" * 501
  end
end

Then /^the deck is not updated$/ do
  deck = Deck.first

  deck.name.should_not == ""
  deck.description.should_not == "X" * 501
end

Then /^I should be on the edit deck page$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
    page.is_current_page?.should == true
  end
end

When /^I go to the edit deck page$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
  end
end

Then /^the deck should be deleted$/ do
  lambda {Deck.find(@current_deck.id)}.should raise_exception
end

Given /^I go to the user home page$/ do
  goto_page :UserHomePage, Capybara.current_session do |page|
  end
end

Then /^I can see all of my decks$/ do
  decks = Deck.where(:user_id => @current_user.first.id)

  decks.each do |deck|
    And %{I should see "#{deck.name}"}
    And %{I should see "#{deck.description}"}
    And %{I should see "#{deck.pronunciation_side}"}
  end
end

Then /^I will not see decks created by other users$/ do
  decks = Deck.all

  decks.each do |deck|
    if deck.user_id != @current_user.first.id
      And %{I should not see "#{deck.name}"}

      unless deck.description.nil?
        And %{I should not see "#{deck.description}"}
      end
    end
  end
end


Then /^I should be redirected to the edit deck page$/ do
  on_page :EditDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^I have created many items in the deck$/ do
  5.times do
    card = Card.make
    card.deck = @current_deck
    card.save!
  end
end

Given /^a deck created by another user that is shared$/ do
  another_user = User.make
  @current_deck = Deck.make(:name => "SimpleDeck", :shared => true, :user_id => another_user.id)
end

Then /^I will see shared decks created by other users$/ do
  decks = Deck.all
  
  decks.each do |deck|
    if deck.user_id != @current_user.first.id
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

Then /^the deck will be shared$/ do
  @current_deck.reload
  @current_deck.shared.should == true
end

Then /^the deck will no longer be shared$/ do
  @current_deck.reload
  @current_deck.shared.should == false
end

Given /^I have created a shared deck$/ do
  @current_deck = Deck.make(:name => "My Deck", :shared => true, :user_id => @current_user.first.id)
end

Then /^I should see the card count$/ do
  card_count = Card.where(:deck_id => @current_deck.id).count
  And %{I should see "#{card_count}"}
end

Then /^I should see the card due count$/ do
  due_count = UserCardSchedule.get_due_count_for_user_for_deck(@current_user[0].id, @current_deck.id)

  And %{I should see "#{due_count}"}
end

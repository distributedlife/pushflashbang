Given /^I am on the create deck page$/ do
  goto_page :CreateDeckPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

When /^I create a deck$/ do
  on_page :CreateDeckPage, Capybara.current_session do |page|
    page.create_deck "my deck", "this is my deck of stuff to learn", "en", "au"
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
  another_user = User.create(:email => "notme@somewhere-else.com", :password => "password", :confirm_password => "password")
  @current_deck = Deck.new(:name => "SimpleDeck", :lang => "en", :country => "au")
  @current_deck.user = another_user
  @current_deck.save!
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
  @current_deck = Deck.new(:name => "My Deck", :lang => "en", :country => "au")
  @current_deck.user = @current_user.first
  @current_deck.save!
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
    page.lang = "zz"
    page.country = "aaa"
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
    And %{I should see "zz"}
    And %{I should see "aaa"}
  end
end

Given /^I edit all deck properties to be invalid$/ do
  goto_page :EditDeckPage, Capybara.current_session, @current_deck.id do |page|
    page.name = ""
    page.description = "X" * 501
    page.lang = ""
    page.country = ""
  end
end

Then /^the deck is not updated$/ do
  deck = Deck.first

  deck.name.should_not == ""
  deck.description.should_not == "X" * 501
  deck.lang.should_not == ""
  deck.country.should_not == ""
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
    And %{I should see "#{deck.lang}"}
    And %{I should see "#{deck.country}"}
  end
end

Then /^I will not see decks created by other users$/ do
  decks = Deck.all

  decks.each do |deck|
    if deck.user_id != @current_user.first.id
      And %{I should not see "#{deck.name}"}
      And %{I should not see "#{deck.lang}"}
      And %{I should not see "#{deck.country}"}

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
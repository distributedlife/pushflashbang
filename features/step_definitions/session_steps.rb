Given /^reference data has been loaded$/ do
  CardTiming.create(:seconds => 5)                            # 5 seconds
  CardTiming.create(:seconds => 25)                           # 25 seconds
  CardTiming.create(:seconds => 60 * 2)        # 2 minutes
  CardTiming.create(:seconds => 60 * 10)       # 10 minutes
  CardTiming.create(:seconds => 60 * 60)              # 1 hour
  CardTiming.create(:seconds => 60 * 60  * 5)          # 5 hours
  CardTiming.create(:seconds => 60 * 60 * 24)               # 1 day
  CardTiming.create(:seconds => 60 * 60 * 24 * 5)           # 5 days
  CardTiming.create(:seconds => 60 * 60 * 24 * 25)          # 25 days
  CardTiming.create(:seconds => 60 * 60 * 24 * 30 * 4)         # 4 months
  CardTiming.create(:seconds => 60 * 60 * 24 * 365 * 2)          # 2 years
end


Given /^I have not performed any sessions before$/ do
  UserCardSchedule.delete_all
end

When /^I go to the deck session page$/ do
  goto_page :DeckSessionPage, Capybara.current_session, @current_deck.id do |page|
  end
end

Then /^the first card in the deck is scheduled$/ do
  UserCardSchedule.count.should == 1
  UserCardSchedule.first.card_id.should == Card.order(:created_at).where(:deck_id => @current_deck.id).first.id
end

Then /^the first card in the deck is shown$/ do
  scheduled_card = Card.find(UserCardSchedule.first.card_id)

  And %{I should see "#{scheduled_card.front}"}
end

Given /^there are cards due$/ do
  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 1.day.ago, :interval => 0)

  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 2.days.ago, :interval => 0)

  @first_due_card = card
end

Given /^there are cards due later$/ do
  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 2.days.from_now, :interval => 0)
end

Given /^there are unscheduled cards$/ do
  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
end

Then /^the first due card is shown$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", @current_user[0].id, Time.now]).card_id)
  And %{I should see "#{scheduled_card.front}"}
end

Given /^there are no cards due$/ do
  UserCardSchedule.all.each do |card_schedule|
    card_schedule.due = 1.day.from_now
    card_schedule.save!
  end
end

Then /^the first unscheduled card is scheduled$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")


  UserCardSchedule.last.card_id.should == cards.first.id
  UserCardSchedule.last.user_id.should == @current_user[0].id
end

Then /^the first unscheduled card is shown$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")

  And %{I should see "#{cards.first.front}"}
end

Given /^there are no unscheduled cards$/ do
  Card.all.each do |card|
    if UserCardSchedule.where(:card_id => card.id, :user_id => @current_user[0].id).count == 0
      UserCardSchedule.create(:card_id => card.id, :user_id => @current_user[0].id, :due => 1.day.from_now, :interval => 0)
    end
  end
end

Then /^I should see when each card is scheduled to be reviewed$/ do
  UserCardSchedule.all.each do |scheduled_card|
    And %{I should see "#{Card.find(scheduled_card.card_id).front}"}
    And %{I should see "#{scheduled_card.due.strftime("%d-%b-%Y @ %H:%M:%S")}"}
  end
end

Given /^there are no cards in the deck$/ do
  Card.delete_all(:deck_id => @current_deck.id)
end

Then /^the number of cards due is shown$/ do
  And %{I should see "#{UserCardSchedule.get_due_count_for_user(@current_user[0].id)}"}
end

Given /^I am reviewing a card$/ do
  Given %{there are cards due}
  When %{I go to the deck session page}
end

Then /^I should see the back of the card$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", @current_user[0].id, Time.now]).card_id)
  And %{I should see "#{scheduled_card.back}"}
end

Given /^I have reviewed a card$/ do
  Given %{there are cards due}
  And %{I go to the deck session page}
  And %{I click on "Reveal"}
end

Then /^I should be redirected to the deck session page$/ do
  on_page :DeckSessionPage, Capybara.current_session do |page|
    page.is_current_page?
  end
end

Then /^the card should be rescheduled$/ do
  scheduled_card = UserCardSchedule.where(:card_id => @first_due_card.id, :user_id => @current_user[0].id).first
  scheduled_card.due.should >= Time.now
  scheduled_card.interval.should == 5
end

Then /^the card interval should be increased$/ do
  scheduled_card = UserCardSchedule.where(:card_id => @first_due_card.id, :user_id => @current_user[0].id).first
  scheduled_card.interval.should == 5
end

Then /^the card interval should be reset$/ do
  scheduled_card = UserCardSchedule.where(:card_id => @first_due_card.id, :user_id => @current_user[0].id).first
  scheduled_card.interval.should == 5
end

When /^a card is scheduled$/ do
  And %{I go to the deck session page}
end

Then /^the date the card is scheduled is recorded$/ do
  UserCardSchedule.first.created_at.should >= Time.now - 5
  UserCardSchedule.first.created_at.should <= Time.now
end

When /^I record my result$/ do
  And %{I click on "I knew the answer"}
end

Then /^the review contains the time the card was due$/ do
  user_card_review = UserCardReview.first
  user_card_schedule = UserCardSchedule.first

  #TODO work out someway of having this value before the change
  user_card_review.due.should_not == user_card_schedule.due
  user_card_review.due.should <= Time.now
end

Then /^the review contains the time the card was reviewed$/ do
  user_card_review = UserCardReview.first

  user_card_review.review_start.should >= Time.now - 5
  user_card_review.review_start.should <= Time.now
end

Then /^the review contains the time the card was revealed$/ do
  user_card_review = UserCardReview.first

  user_card_review.reveal.should >= Time.now - 5
  user_card_review.reveal.should <= Time.now
end

Then /^the review contains the time the result was recorded$/ do
  user_card_review = UserCardReview.first

  user_card_review.result_recorded.should >= Time.now - 5
  user_card_review.result_recorded.should <= Time.now
end

Then /^the review contains the outcome of the result$/ do
  user_card_review = UserCardReview.first

  user_card_review.result_success.should == "good"
end

Then /^the review contains the interval of the review$/ do
  user_card_review = UserCardReview.first

  user_card_review.interval.should == 0
end

When /^I review the same card again$/ do
  card_schedule = UserCardSchedule.where(:card_id => @first_due_card.id).first
  card_schedule.due = 10.days.ago
  card_schedule.save!

  And %{I go to the deck session page}
  And %{I click on "Reveal"}
  And %{I click on "I knew the answer"}
end

Then /^there should be two reviews for the same card$/ do
  UserCardReview.where(:card_id => @first_due_card.id).count.should == 2
end

When /^a new card is scheduled$/ do
  Given %{there are no cards due}
  And %{there are cards due later}
  And %{there are unscheduled cards}
  When %{I go to the deck session page}
end

When /^I click on the "([^"]*)" button$/ do |button_number|
  if button_number == "first"
    And %{I click on "I didn't know the answer"}
  elsif button_number == "second"
    And %{I click on "I knew some of the answer"}
  elsif button_number == "third"
    And %{I click on "I was shaky but I got it"}
  elsif button_number == "fourth"
    And %{I click on "I knew the answer"}
  end
end

When /^the card interval is (\d+)$/ do |interval|
  card_schedule = UserCardSchedule.where(:card_id => @first_due_card.id).first
  card_schedule.interval = interval
  card_schedule.save!
end

Given /^I have reviewed a card with an interval of (\d+)$/ do |interval|
  Given %{there are cards due}
  And %{the card interval is #{interval}}
  And %{I go to the deck session page}
  And %{I click on "Reveal"}
end

Then /^the "([^"]*)" button is "([^"]*)"$/ do |button_number, style|
  if button_number == "first"
    find_link("I didn't know the answer")[:class].should == style
  elsif button_number == "second"
    find_link("I knew some of the answer")[:class].should == style
  elsif button_number == "third"
    find_link("I was shaky but I got it")[:class].should == style
  elsif button_number == "fourth"
    find_link("I knew the answer")[:class].should == style
  end
end
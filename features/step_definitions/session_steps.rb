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
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 1.day.ago, :interval => CardTiming::get_first.seconds)

  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 2.days.ago, :interval => CardTiming::get_first.seconds)

  @first_due_card = card
end

Given /^there are cards due later$/ do
  card = Card.new(:front => Faker::Lorem.sentence(1), :back => Faker::Lorem.sentence(1))
  card.deck = @current_deck
  card.save!
  UserCardSchedule.create(:user_id => @current_user[0].id, :card_id => card.id, :due => 2.days.from_now, :interval => CardTiming::get_first.seconds)
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
      UserCardSchedule.create(:card_id => card.id, :user_id => @current_user[0].id, :due => 1.day.from_now, :interval => 5)
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

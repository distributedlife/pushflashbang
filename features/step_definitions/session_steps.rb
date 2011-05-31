And /^reference data has been loaded$/ do
  CardTiming.create(:seconds => 5)                            # 5 seconds
  CardTiming.create(:seconds => 25)                           # 25 seconds
  CardTiming.create(:seconds => 60 * 2)                       # 2 minutes
  CardTiming.create(:seconds => 60 * 10)                      # 10 minutes
  CardTiming.create(:seconds => 60 * 60)                      # 1 hour
  CardTiming.create(:seconds => 60 * 60  * 5)                 # 5 hours
  CardTiming.create(:seconds => 60 * 60 * 24)                 # 1 day
  CardTiming.create(:seconds => 60 * 60 * 24 * 5)             # 5 days
  CardTiming.create(:seconds => 60 * 60 * 24 * 25)            # 25 days
  CardTiming.create(:seconds => 60 * 60 * 24 * 30 * 4)        # 4 months
  CardTiming.create(:seconds => 60 * 60 * 24 * 365 * 2)       # 2 years
end

And /^there are cards due$/ do
  add(:card, Card.make(:deck_id => get(:deck_id)))
  add(:card_id, get(:card).id)
  add(:user_card_schedule, UserCardSchedule.make(:due, :user_id => get(:user_id), :card_id => get(:card).id))

  add(:card, Card.make(:deck_id => get(:deck_id)))
  add(:card_id, get(:card).id)
  add(:user_card_schedule, UserCardSchedule.make(:user_id => get(:user_id), :card_id => get(:card).id, :due => 2.days.ago))
end

And /^the next due card is in the current chapter$/ do
  user_deck = UserDeckChapter.where(:user_id => get(:user_id), :deck_id => get(:deck_id)).first
  if user_deck.nil?
    user_deck = UserDeckChapter.make(:user_id => get(:user_id), :deck_id => get(:deck_id))
    add(:user_deck, user_deck)
  end

  get(:card).chapter = user_deck.chapter
  get(:card).save!
end

And /^the next due card is in the next chapter$/ do
  user_deck = UserDeckChapter.where(:user_id => get(:user_id), :deck_id => get(:deck_id))
  user_deck = UserDeckChapter.make(:user_id => get(:user_id), :deck_id => get(:deck_id)) unless user_deck.nil?

  #all scheduled cards are made not due
  And %{there are no cards due}

  Card.all.each do |card|
    next unless UserCardSchedule.where(:user_id => get(:user_id), :card_id => card.id).first.nil?

    card.chapter = user_deck.chapter + 1
    card.save!
    add(:card, Card.make(:deck_id => get(:deck_id), :chapter => user_deck.chapter + 1))
    add(:card_id, card.id)
  end

  add(:card, Card.make(:deck_id => get(:deck_id), :chapter => user_deck.chapter + 1))
end

And /^the first due card is shown$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", get(:user_id), Time.now]).card_id)
  And %{I should see "#{scheduled_card.front}"}
end

When /^I have reviewed a card with an interval of (\d+)$/ do |interval|
  Given %{there are cards due}
  And %{the card interval is #{interval}}
  And %{I go to the "deck session" page}
  And %{I click on "Reveal"}
end

When /^I have reviewed a new card$/ do
  Given %{there are cards due}
  And %{I go to the "deck session" page}
  And %{I click on "Reveal"}
end

And /^the card has been reviewed before$/ do
  UserCardReview.make(:card_id => get(:card_id), :user_id => get(:user_id))
end

And /^I take (\d+) seconds to review a card that is not new$/ do |seconds|
  And %{there are cards due}
  And %{the card has been reviewed before}
  And %{I go to the "deck session" page}
  sleep seconds.to_i
  And %{I click on "Reveal"}
end


And /^a new card is scheduled$/ do
  And %{there are no cards due}
  And %{there are cards due later}
  And %{there are unscheduled cards}
  And %{I go to the "deck session" page}
end

And /^I have reviewed a card$/ do
  And %{there are cards due}
  And %{I go to the "deck session" page}
  And %{I click on "Reveal"}
end

And /^I am reviewing a card$/ do
  And %{there are cards due}
  And %{I go to the "deck session" page}
end

When /^a card is scheduled$/ do
  And %{I go to the "deck session" page}
end

And /^I record my result$/ do
  And %{I click on "I knew the answer"}
end

And /^I review the same card again$/ do
  card_schedule = UserCardSchedule.where(:card_id => get(:card_id)).first
  card_schedule.due = 10.days.ago
  card_schedule.save!

  And %{I go to the "deck session" page}
  And %{I click on "Reveal"}
  And %{I click on "I knew the answer"}
end

And /^the card interval should be (\d+)$/ do |interval|
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.interval.to_s.should == interval
end

And /^the interval should be (\d+) to the next plus or minus (\d+) seconds$/ do |interval, range|
  interval = interval.to_i
  range = range.to_i

  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.interval.should >= interval - range
  scheduled_card.interval.should <= interval + range
  scheduled_card.interval.should_not == interval
end

And /^the card should be rescheduled$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.due.should >= Time.now
end

And /^the card interval should be increased$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.interval.should == 5
end

And /^the card interval should be reset$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.interval.should == 5
end

And /^the card interval should be increased by two$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user_id)).first
  scheduled_card.interval.should == 25
end

And /^the date the card is scheduled is recorded$/ do
  UserCardSchedule.first.created_at.should >= Time.now - 5
  UserCardSchedule.first.created_at.should <= Time.now
end

And /^the review contains the time the card was due$/ do
  user_card_review = UserCardReview.first
  user_card_schedule = UserCardSchedule.first

  user_card_review.due.should_not == user_card_schedule.due
  user_card_review.due.should <= Time.now
end

And /^the review contains the time the card was reviewed$/ do
  user_card_review = UserCardReview.first

  user_card_review.review_start.should >= Time.now - 5
  user_card_review.review_start.should <= Time.now
end

And /^the review contains the time the card was revealed$/ do
  user_card_review = UserCardReview.first

  user_card_review.reveal.should >= Time.now - 5
  user_card_review.reveal.should <= Time.now
end

And /^the review contains the time the result was recorded$/ do
  user_card_review = UserCardReview.first

  user_card_review.result_recorded.should >= Time.now - 5
  user_card_review.result_recorded.should <= Time.now
end

And /^the review contains the outcome of the result$/ do
  user_card_review = UserCardReview.first

  user_card_review.result_success.should == "good"
end

And /^the review contains the interval of the review$/ do
  user_card_review = UserCardReview.first

  user_card_review.interval.should == 0
end

And /^there should be two reviews for the same card$/ do
  UserCardReview.where(:card_id => get(:card_id)).count.should == 2
end

And /^I have not performed any sessions before$/ do
  UserCardSchedule.delete_all
end

And /^the first card in the deck is scheduled$/ do
  UserCardSchedule.count.should == 1
  UserCardSchedule.first.card_id.should == Card.order(:created_at).where(:deck_id => get(:deck_id)).first.id
end

And /^the first card in the deck is shown$/ do
  scheduled_card = Card.find(UserCardSchedule.first.card_id)

  And %{I should see "#{scheduled_card.front}"}
end

And /^there are unscheduled cards$/ do
  card = Card.make(:deck_id => get(:deck_id))
end

And /^there are cards due later$/ do
  card = Card.make(:deck_id => get(:deck_id))
  UserCardSchedule.make(:user_id => get(:user_id), :card_id => card.id, :due => 2.days.from_now)
end

And /^the first unscheduled card is scheduled$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")


  UserCardSchedule.last.card_id.should == cards.first.id
  UserCardSchedule.last.user_id.should == get(:user_id)
end

And /^the first unscheduled card is shown$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")

  And %{I should see "#{cards.first.front}"}
end

And /^there are no unscheduled cards$/ do
  Card.all.each do |card|
    if UserCardSchedule.where(:card_id => card.id, :user_id => get(:user_id)).count == 0
      UserCardSchedule.create(:card_id => card.id, :user_id => get(:user_id), :due => 1.day.from_now, :interval => 0)
    end
  end
end

And /^there are no cards in the deck$/ do
  Card.delete_all(:deck_id => get(:deck_id))
end

And /^the number of cards due is shown$/ do
  And %{I should see "#{UserCardSchedule.get_due_count_for_user(get(:user_id))}"}
end

And /^I should see the back of the card$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", get(:user_id), Time.now]).card_id)
  And %{I should see "#{scheduled_card.back}"}
end

And /^I click on the "([^"]*)" button$/ do |button_number|
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

And /^the "([^"]*)" button is "([^"]*)"$/ do |button_number, style|
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

And /^there are no cards due$/ do
  UserCardSchedule.all.each do |card_schedule|
    card_schedule.due = 1.day.from_now
    card_schedule.save!
  end
end

And /^I should see when each card is scheduled to be reviewed$/ do
  UserCardSchedule.all.each do |scheduled_card|
    And %{I should see "#{Card.find(scheduled_card.card_id).front}"}
    And %{I should see "due in 1 day"}
  end
end
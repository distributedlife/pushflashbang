# -*- encoding : utf-8 -*-
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
  add(:card, Card.make!(:deck_id => get(:deck_id)))
  add(:card_id, get(:card).id)
  add(:user_card_schedule, UserCardSchedule.make!(:due, :user_id => get(:user).id, :card_id => get(:card).id))

  add(:card, Card.make!(:deck_id => get(:deck_id)))
  add(:card_id, get(:card).id)
  add(:user_card_schedule, UserCardSchedule.make!(:user_id => get(:user).id, :card_id => get(:card).id, :due => 2.days.ago))
end

And /^the next due card is in the current chapter$/ do
  user_deck = UserDeckChapter.where(:user_id => get(:user).id, :deck_id => get(:deck_id)).first
  if user_deck.nil?
    user_deck = UserDeckChapter.make!(:user_id => get(:user).id, :deck_id => get(:deck_id))
    add(:user_deck, user_deck)
  end

  get(:card).chapter = user_deck.chapter
  get(:card).save!
end

And /^the next due card is in the next chapter$/ do
  user_deck = UserDeckChapter.where(:user_id => get(:user).id, :deck_id => get(:deck_id))
  user_deck = UserDeckChapter.make!(:user_id => get(:user).id, :deck_id => get(:deck_id)) unless user_deck.nil?

  #all scheduled cards are made not due
  step %{there are no cards due}

  Card.all.each do |card|
    next unless UserCardSchedule.where(:user_id => get(:user).id, :card_id => card.id).first.nil?

    card.chapter = user_deck.chapter + 1
    card.save!
    add(:card, Card.make!(:deck_id => get(:deck_id), :chapter => user_deck.chapter + 1))
    add(:card_id, card.id)
  end

  add(:card, Card.make!(:deck_id => get(:deck_id), :chapter => user_deck.chapter + 1))
end

And /^the first due card is shown$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", get(:user).id, Time.now]).card_id)
  step %{I should see "#{scheduled_card.front}"}
end

When /^I have reviewed a card with an interval of (\d+)$/ do |interval|
  step %{there are cards due}
  step %{the card interval is #{interval}}
  step %{I go to the "deck session" page}
  step %{I click on "Reveal"}
end

When /^I have reviewed a new card$/ do
  step %{there are cards due}
  step %{I go to the "deck session" page}
  step %{I click on "Reveal"}
end

And /^the card has been reviewed before$/ do
  UserCardReview.make!(:card_id => get(:card_id), :user_id => get(:user).id)
end

And /^I take (\d+) seconds to review a card that is not new$/ do |seconds|
  step %{there are cards due}
  step %{the card has been reviewed before}
  step %{I go to the "deck session" page}
  sleep seconds.to_i
  step %{I click on "Reveal"}
end


And /^a new card is scheduled$/ do
  step %{there are no cards due}
  step %{there are cards due later}
  step %{there are unscheduled cards}
  step %{I go to the "deck session" page}
end

And /^I have reviewed a card$/ do
  step %{there are cards due}
  step %{I go to the "deck session" page}
  step %{I click on "Reveal"}
end

And /^I am reviewing a card$/ do
  step %{there are cards due}
  step %{I go to the "deck session" page}
end

When /^a card is scheduled$/ do
  step %{I go to the "deck session" page}
end

And /^I record my result$/ do
  step %{I click on "Too Easy! Show me this less often"}
  sleep 0.5
end

And /^I review the same card again$/ do
  card_schedule = UserCardSchedule.where(:card_id => get(:card_id)).first
  card_schedule.due = 10.days.ago
  card_schedule.save!

  step %{I go to the "deck session" page}
  step %{I click on "Reveal"}
  step %{I click on "Too Easy! Show me this less often"}
  sleep 0.5
end

And /^the card interval should be (\d+)$/ do |interval|
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.interval.to_s.should == interval
end

And /^the interval should be (\d+) to the next plus up to (\d+) percent$/ do |interval, range|
  interval = interval.to_i
  range = range.to_i
  range = (range / 100) + 1

  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.interval.should >= interval
  scheduled_card.interval.should <= (interval * range)
end

And /^the card should be rescheduled$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.due.utc.should >= Time.now.utc
end

And /^the card interval should be increased$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.interval.should == 5
end

And /^the card interval should be reset$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.interval.should == 5
end

And /^the card interval should be increased to minimum$/ do
  scheduled_card = UserCardSchedule.where(:card_id => get(:card_id), :user_id => get(:user).id).first
  scheduled_card.interval.should >= 3600 - CardTiming::RANGE
  scheduled_card.interval.should <= 3600 + CardTiming::RANGE
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

  step %{I should see "#{scheduled_card.front}"}
end

And /^there are unscheduled cards$/ do
  card = Card.make!(:deck_id => get(:deck_id))
end

And /^there are cards due later$/ do
  card = Card.make!(:deck_id => get(:deck_id))
  UserCardSchedule.make!(:user_id => get(:user).id, :card_id => card.id, :due => 2.days.from_now)
end

And /^the first unscheduled card is scheduled$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")


  UserCardSchedule.last.card_id.should == cards.first.id
  UserCardSchedule.last.user_id.should == get(:user).id
end

And /^the first unscheduled card is shown$/ do
  cards = Card.find_by_sql("SELECT * from cards where id not in (select card_id from user_card_schedules where id not in (select max(id) from user_card_schedules))")

  step %{I should see "#{cards.first.front}"}
end

And /^there are no unscheduled cards$/ do
  Card.all.each do |card|
    if UserCardSchedule.where(:card_id => card.id, :user_id => get(:user).id).count == 0
      UserCardSchedule.create(:card_id => card.id, :user_id => get(:user).id, :due => 1.day.from_now, :interval => 0)
    end
  end
end

And /^there are no cards in the deck$/ do
  Card.delete_all(:deck_id => get(:deck_id))
end

And /^the number of cards due is shown$/ do
  step %{I should see "#{UserCardSchedule.get_due_count_for_user(get(:user).id)}"}
end

And /^I should see the back of the card$/ do
  scheduled_card = Card.find(UserCardSchedule.order(:due).find(:first, :conditions => ["user_id = ? and due <= ?", get(:user).id, Time.now]).card_id)
  step %{I should see "#{scheduled_card.back}"}
end

And /^I click on the "([^"]*)" button$/ do |button_number|
  if button_number == "first"
    step %{I click on "I didn't know the answer"}
  elsif button_number == "second"
    step %{I click on "I knew some of the answer"}
  elsif button_number == "third"
    step %{I click on "I was shaky but I got it"}
  elsif button_number == "fourth"
    step %{I click on "Too Easy! Show me this less often"}
  end
  sleep 0.5
end

And /^the "([^"]*)" button is normal/ do |button_number|
  if button_number == "first"
    find_link("I didn't know the answer")[:class].to_s["nuetral"] == "nuetral"
  elsif button_number == "second"
    find_link("I knew some of the answer")[:class].to_s["nuetral"] == "nuetral"
  elsif button_number == "third"
    find_link("I was shaky but I got it")[:class].to_s["nuetral"] == "nuetral"
  elsif button_number == "fourth"
    find_link("Too Easy! Show me this less often")[:class].to_s["nuetral"] == "nuetral"
  end
end

And /^the "([^"]*)" button is highlighted$/ do |button_number|
  if button_number == "first"
    find_link("I didn't know the answer")[:class].to_s["positive"] == "positive"
  elsif button_number == "second"
    find_link("I knew some of the answer")[:class].to_s["positive"] == "positive"
  elsif button_number == "third"
    find_link("I was shaky but I got it")[:class].to_s["positive"] == "positive"
  elsif button_number == "fourth"
    find_link("Too Easy! Show me this less often")[:class].to_s["positive"] == "positive"
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
    step %{I should see "#{Card.find(scheduled_card.card_id).front}"}
    step %{I should see "due in 1 day"}
  end
end

require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  email {Faker::Internet.email(Faker::Name.first_name)}
  password(:unique => false) {'password'}

  name {Faker::Lorem.words(1)}
  description {Faker::Lorem.sentence(5)}
  shared(:unique => false) {false}
  pronunciation_side(:unique => false) {'front'}
  user_id(:unique => false) {1}

  front {Faker::Lorem.sentence(4)}
  back {Faker::Lorem.sentence(3)}
  pronunciation {Faker::Lorem.sentence(2)}

  deck_id(:unique => false) {1}
  card_id(:unique => false) {1}

  due(:unique => false) {Time.now}
  interval(:unique => false) {0}
  review_start(:unique => false) {Time.now}
  reveal(:unique => false) {Time.now}
  result_recorded(:unique => false) {Time.now}
  result_success(:unique => false) {'good'}
end

User.blueprint do
  email
  password
end

Deck.blueprint do
  name
  description
  shared
  pronunciation_side
  user_id
  review_types {Deck::READING}
end

Card.blueprint do
  deck_id
  front
  back
  pronunciation
  chapter {1}
end

UserCardReview.blueprint do
  card_id
  user_id
  due
  review_start
  reveal
  result_recorded
  result_success
  interval
end

UserCardSchedule.blueprint do
  user_id
  card_id
  due {1.day.from_now}
  interval
end

UserCardSchedule.blueprint(:due) do
  user_id
  card_id
  due {1.day.ago}
  interval
end

UserDeckChapter.blueprint do
  user_id
  deck_id
  chapter {1}
end
require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  #users
  email {Faker::Internet.email(Faker::Name.first_name)}
  password(:unique => false) {'password'}

  #cards and decks
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
  idiom_id(:unique => false) {1}

  due(:unique => false) {Time.now}
  interval(:unique => false) {0}
  review_start(:unique => false) {Time.now}
  reveal(:unique => false) {Time.now}
  result_recorded(:unique => false) {Time.now}
  result_success(:unique => false) {'good'}

  #terms and idioms
  language(:unique => false) {'English'}
  form(:unique => false) {Faker::Lorem.sentence(4)}
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

Idiom.blueprint do

end

Translation.blueprint do
  language
  form
  pronunciation
end

IdiomTranslation.blueprint do
  idiom_id
  translation_id
end

Language.blueprint do
  name {Faker::Lorem.sentence(2)}
end

UserLanguages.blueprint do
  language_id
  user_id
end

Sets.blueprint do

end

SetName.blueprint do
  name {Faker::Lorem.sentence(2)}
  description {Faker::Lorem.sentence(5)}
end

SetTerms.blueprint do
  chapter {1}
  position {1}
end

UserIdiomReview.blueprint do
  user_id
  idiom_id
  review_type {1}
  due
  review_start
  reveal
  result_recorded
  result_success
  interval
end

UserIdiomSchedule.blueprint do
  user_id
  idiom_id
end

UserIdiomDueItems.blueprint do
  review_type {1}
  due
  interval
end

UserSets.blueprint do
  user_id
  set_id
  chapter {1}
end
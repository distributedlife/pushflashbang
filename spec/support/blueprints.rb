require 'machinist/active_record'
require 'faker'

User.blueprint do
  email {Faker::Internet.email(Faker::Name.first_name)}
  password {'password'}
  native_language_id {1}
  edit_mode {true}
end

Deck.blueprint do
  name {Faker::Lorem.words(1)}
  description {Faker::Lorem.sentence(5)}
  shared {false}
  pronunciation_side {'front'}
  user_id {1}
  review_types {Deck::READING}
end

Card.blueprint do
  deck_id {1}
  front {Faker::Lorem.sentence(4)}
  back {Faker::Lorem.sentence(3)}
  pronunciation {Faker::Lorem.sentence(2)}
  chapter {1}
end

UserCardReview.blueprint do
  card_id {1}
  user_id {1}
  due {Time.now}
  review_start {Time.now}
  reveal {Time.now}
  result_recorded {Time.now}
  result_success {'good'}
  interval {0}
end

UserCardSchedule.blueprint do
  user_id {1}
  card_id {1}
  due {1.day.from_now}
  interval {0}
end

UserCardSchedule.blueprint(:due) do
  user_id {1}
  card_id {1}
  due {1.day.ago}
  interval {0}
end

UserDeckChapter.blueprint do
  user_id {1}
  deck_id {1}
  chapter {1}
end

Idiom.blueprint do
  idiom_type {'v'}
end

Translation.blueprint do
  idiom_id {1}
  language_id {1}
  form {Faker::Lorem.sentence(4)}
  pronunciation {}
end

Language.blueprint do
  name {Faker::Lorem.sentence(2)}
  enabled {true}
end

UserLanguages.blueprint do
  language_id {1}
  user_id {1}
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
  user_id {1}
  idiom_id {1}
  language_id {1}
  review_type {1}
  due {Time.now}
  review_start {Time.now}
  reveal {Time.now}
  result_recorded {Time.now}
#  success {true}
  interval {5}
end

UserIdiomSchedule.blueprint do
  user_id {1}
  idiom_id {1}
  language_id {1}
end

UserIdiomDueItems.blueprint do
  review_type {1}
  due {Time.now}
  interval {0}
end

UserSets.blueprint do
  user_id {1}
  set_id {1}
  language_id {1}
  chapter {1}
end

RelatedTranslations.blueprint do
  translation1_id {1}
  translation2_id {1}
  share_meaning {false}
  share_written_form {false}
  share_audible_form {false}
end
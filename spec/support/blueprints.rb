require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  name {Faker::Lorem.sentences(1)}
  description {Faker::Lorem.paragraphs(1)}
  lang(:unique => false) {'en'}
  country(:unique => false) {'au'}
  user(:unique => false) {@user}
end

#blueprint :deck do
#  deck = Deck.new(name, description, lang, country)
#  deck.user = @current_user
#
#  deck
#end

#Deck.blueprint do
#  name
#  description
#  lang
#  country
#  user {@user}
#end
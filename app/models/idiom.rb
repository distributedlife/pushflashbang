class Idiom < ActiveRecord::Base
  has_many :idiom_translation
  has_many :translations, :through => :idiom_translation
end
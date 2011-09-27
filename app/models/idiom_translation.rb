#class IdiomTranslation < ActiveRecord::Base
#  validates :idiom_id, :presence => true
#  validates :translation_id, :presence => true
#
#  belongs_to :idiom
#  belongs_to :translation
#
#  def self.translations_share_idiom? t1_id, t2_id
#    IdiomTranslation.where(:translation_id => t1_id).each do |it1|
#      IdiomTranslation.where(:translation_id => t2_id).each do |it2|
#        return true if it1.idiom_id == it2.idiom_id
#      end
#    end
#
#    false
#  end
#end
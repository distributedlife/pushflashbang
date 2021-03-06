# -*- encoding : utf-8 -*-
class Card < ActiveRecord::Base
  has_paper_trail
  has_attached_file :audio,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "audio/:id/#{Digest::MD5::hexdigest(":id").upcase}.:extension"
  
  belongs_to :deck
  has_many :user_card_schedule

  attr_accessible :front, :back, :pronunciation, :chapter, :audio

  validates :front, :presence => true
  validates :deck_id, :presence => true
  validates :chapter, :presence => true, :numericality => { :greater_than => 0 }

  def self.get_first_unscheduled_card_for_deck_for_user user_id, deck_id
    sql = <<-SQL
      SELECT *
      FROM cards
      WHERE deck_id = #{deck_id}
      AND id NOT IN
      (
        SELECT card_id
        FROM user_card_schedules
        WHERE user_id = #{user_id}
      )
      ORDER BY created_at ASC
    SQL

    card = Card.find_by_sql(sql)

    if card.empty?
      nil
    else
      card.first
    end
  end

  def delete
    UserCardSchedule.where(:card_id => self.id).each do |card_schedule|
      card_schedule.delete
    end

    self.audio.destroy unless self.audio.file?

    return super
  end
end

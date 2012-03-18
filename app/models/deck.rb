# -*- encoding : utf-8 -*-
class Deck < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  has_many :cards, :class_name => "Card", :foreign_key => "deck_id"

  attr_accessible :name, :description, :shared, :pronunciation_side, :supports_written_answer, :review_types

  SIDES = ['front', 'back']

  READING = 1
  WRITING = 2
  TYPING = 4
  HEARING = 8
  SPEAKING = 16

  REVIEW_TYPES = [READING, WRITING, TYPING, HEARING, SPEAKING]

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :user_id, :presence => true
  validates :pronunciation_side, :presence => true
  validates_inclusion_of :pronunciation_side, :in => SIDES

  def delete
    UserDeckChapter.where(:deck_id => self.id).each do |deck_chapter|
      deck_chapter.delete
    end

    Card.where(:deck_id => self.id).each do |card|
      card.delete
    end

    return super
  end

  def get_chapters
    sql = <<-SQL
      SELECT chapter
      FROM cards
      WHERE deck_id = #{self.id}
      GROUP BY chapter
      ORDER BY chapter ASC
    SQL

    Card.find_by_sql(sql)
  end

  def self.get_visible_decks_for_user user_id
    Deck.order(:name).where("user_id = :user_id OR shared = :shared", :user_id => user_id, :shared => true)
  end
end

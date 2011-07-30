class SetTerms < ActiveRecord::Base
  has_many :idioms, :class_name => "Idiom", :primary_key => :term_id, :foreign_key => :id

  attr_accessible :set_id, :term_id, :chapter, :position
  
  validates :set_id, :presence => true
  validates :term_id, :presence => true
  validates :chapter, :presence => true
  validates :position, :presence => true

  def self.increment_chapters_for_set set_id
    self.where(:set_id => set_id).each do |set_term|
      set_term.chapter = set_term.chapter + 1
      set_term.save
    end
  end

  def self.decrement_chapters_for_set_after_chapter set_id, chapter
    self.where(:set_id => set_id).each do |set_term|
      if set_term.chapter > chapter
        set_term.chapter = set_term.chapter - 1
        set_term.save
      end
    end
  end
end

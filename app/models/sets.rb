# -*- encoding : utf-8 -*-
class Sets < ActiveRecord::Base
  has_many :set_name
  has_many :set_terms, :class_name => "SetTerms", :foreign_key => "set_id"

  def delete
    SetName.where(:sets_id => self.id).each do |set_name|
      set_name.delete
    end

    return super
  end

  def self.exists? id
    begin
      Sets.find(id)

      true
    rescue
      false
    end
  end

  def add_term term_id
    return unless SetTerms.where(:set_id => self.id, :term_id => term_id).empty?

    max_position = SetTerms.where(:set_id => self.id).maximum(:position)
    max_position ||= 0
    max_chapter = SetTerms.where(:set_id => self.id).maximum(:chapter)
    max_chapter ||= 1

    SetTerms.create(:set_id => self.id, :term_id => term_id, :chapter => max_chapter, :position => max_position + 1)
  end

  def has_at_least_one_idiom_for_language language_id
    language_id = language_id.to_i
    set_id = set_id.to_i

    SetTerms.where(:set_id => self.id).each do |set_terms|
      Translation.where(:idiom_id => set_terms.term_id).each do |translation|
        return true if translation.language_id == language_id
      end
    end

    false
  end

  def remove_gaps_in_ordering
    chapter = 0
    last_chapter = 0
    SetTerms.order(:chapter, :position).where(:set_id => self.id).each_with_index do |set_term, index|
      if set_term.chapter != last_chapter
        chapter += 1
        last_chapter = set_term.chapter
      end
      
      set_term.chapter = chapter
      set_term.position = index + 1
      set_term.save!
    end
  end

  def self.all_containing_idiom idiom_id
    Sets.joins(:set_terms).where(:set_terms => {:term_id => idiom_id})
  end

  def self.all_not_containing_idiom idiom_id
    sql = <<-SQL
      SELECT *
      FROM SETS
      WHERE id NOT IN
      (
        SELECT set_id
        FROM set_terms
        WHERE term_id = #{idiom_id}
      )
    SQL
    
    Sets.find_by_sql(sql)
  end
end

class IntroduceWordsConcept < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.text :target
      t.text :native
      t.text :pronunciation
      t.text :grammatical_form
      t.text :target_language
      t.text :native_language

      t.timestamps
    end


    create_table :related_words do |t|
      t.integer :word_id
      t.integer :related_word_id
      t.string :relationship
    end
  end

  def self.down
    drop_table :related_words
    drop_table :words
  end
end

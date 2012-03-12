# -*- encoding : utf-8 -*-
class IntroduceLanguageConcept < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name

      t.timestamps
    end

    create_table :user_languages do |t|
      t.references :user
      t.references :language

      t.timestamps
    end
  end

  def self.down
    drop_table :user_languages
    drop_table :languages
  end
end

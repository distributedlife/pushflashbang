# -*- encoding : utf-8 -*-
class AddChapter < ActiveRecord::Migration
  def self.up
    add_column :cards, :chapter, :integer

    execute <<-SQL
      UPDATE cards
      SET chapter = 1
    SQL

    create_table :user_deck_chapters do |t|
      t.belongs_to :user
      t.references :deck
      t.integer :chapter

      t.timestamps
    end
  end

  def self.down
    drop_table :user_deck_chapters
    remove_column :cards, :chapter
  end
end

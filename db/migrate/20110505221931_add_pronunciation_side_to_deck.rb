# -*- encoding : utf-8 -*-
class AddPronunciationSideToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :pronunciation_side, :string

    execute <<-SQL
      UPDATE decks
      SET pronunciation_side = 'back'
    SQL
  end

  def self.down
    remove_column :decks, :pronunciation_side
  end
end

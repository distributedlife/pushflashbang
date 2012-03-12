# -*- encoding : utf-8 -*-
class AddSupportWrittenAnswerToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :supports_written_answer, :boolean

    execute <<-SQL
      UPDATE decks
      SET supports_written_answer = 'f'
    SQL
  end

  def self.down
    remove_column :decks, :support_written_answer
  end
end

class AddPronunciationToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :pronunciation, :string
  end

  def self.down
    remove_column :cards, :pronunciation
  end
end

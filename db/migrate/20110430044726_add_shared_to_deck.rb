class AddSharedToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :shared, :boolean, :default => false
  end

  def self.down
    remove_column :decks, :shared
  end
end

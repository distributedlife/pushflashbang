class CreateDecks < ActiveRecord::Migration
  def self.up
    create_table :decks do |t|
      t.string :name, :limit => 40
      t.text :description
      t.string :lang, :limit => 3
      t.string :country, :limit => 3
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :decks
  end
end

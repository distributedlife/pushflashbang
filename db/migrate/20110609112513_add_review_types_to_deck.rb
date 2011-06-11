class AddReviewTypesToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :review_types, :integer
  end

  def self.down
    remove_column :decks, :review_types
  end
end

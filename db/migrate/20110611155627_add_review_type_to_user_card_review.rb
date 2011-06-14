class AddReviewTypeToUserCardReview < ActiveRecord::Migration
  def self.up
    add_column :user_card_reviews, :review_type, :integer
  end

  def self.down
    remove_column :user_card_reviews, :review_type
  end
end

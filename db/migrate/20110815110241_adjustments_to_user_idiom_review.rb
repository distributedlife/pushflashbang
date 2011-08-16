class AdjustmentsToUserIdiomReview < ActiveRecord::Migration
  def self.up
    remove_column :user_idiom_reviews, :result_success
    add_column :user_idiom_reviews, :success, :boolean
  end

  def self.down
    add_column :user_idiom_reviews, :result_success, :string
    remove_column :user_idiom_reviews, :success
  end
end

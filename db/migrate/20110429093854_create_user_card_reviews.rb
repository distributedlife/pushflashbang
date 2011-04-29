class CreateUserCardReviews < ActiveRecord::Migration
  def self.up
    create_table :user_card_reviews do |t|
      t.belongs_to  :user
      t.belongs_to  :card
      t.datetime    :due
      t.datetime    :review_start
      t.datetime    :reveal
      t.datetime    :result_recorded, :default => false
      t.boolean     :result_success
      t.integer     :interval

      t.timestamps
    end
  end

  def self.down
    drop_table :user_card_reviews
  end
end

# -*- encoding : utf-8 -*-
class CreateUserIdiomReviews < ActiveRecord::Migration
  def self.up
    create_table :user_idiom_reviews do |t|
      t.belongs_to  :user
      t.belongs_to  :idiom
      t.integer     :review_type
      t.datetime    :due
      t.datetime    :review_start
      t.datetime    :reveal
      t.datetime    :result_recorded
      t.string      :result_success
      t.integer     :interval

      t.timestamps
    end
  end

  def self.down
    drop_table :user_idiom_reviews
  end
end

# -*- encoding : utf-8 -*-
class AddLanguageToUserIdiomReview < ActiveRecord::Migration
  def self.up
    add_column :user_idiom_reviews, :language_id, :integer
  end

  def self.down
    remove_column :user_idiom_reviews, :language_id
  end
end

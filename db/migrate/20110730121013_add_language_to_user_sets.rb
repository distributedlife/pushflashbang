# -*- encoding : utf-8 -*-
class AddLanguageToUserSets < ActiveRecord::Migration
  def self.up
    add_column :user_sets, :language_id, :integer
  end

  def self.down
    remove_column :user_sets, :language_id
  end
end

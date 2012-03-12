# -*- encoding : utf-8 -*-
class AddLanguageToUserIdiomSchedule < ActiveRecord::Migration
  def self.up
    add_column :user_idiom_schedules, :language_id, :integer
  end

  def self.down
    remove_column :user_idiom_schedules, :language_id
  end
end

# -*- encoding : utf-8 -*-
class CreateUserIdiomSchedules < ActiveRecord::Migration
  def self.up
    create_table :user_idiom_schedules do |t|
      t.belongs_to :user
      t.belongs_to :idiom

      t.timestamps
    end

    create_table :user_idiom_due_items do |t|
      t.belongs_to :user_idiom_schedule
      t.integer     :review_type
      t.integer     :interval
      t.datetime    :due

      t.timestamps
    end
  end

  def self.down
    drop_table :user_idiom_due_items
    drop_table :user_idiom_schedules
  end
end

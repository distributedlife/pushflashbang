# -*- encoding : utf-8 -*-
class CreateUserCardSchedules < ActiveRecord::Migration
  def self.up
    create_table :user_card_schedules do |t|
      t.belongs_to :user
      t.belongs_to :card
      t.datetime :due
      t.integer :interval

      t.timestamps
    end
  end

  def self.down
    drop_table :user_card_schedules
  end
end

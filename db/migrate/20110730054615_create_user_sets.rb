# -*- encoding : utf-8 -*-
class CreateUserSets < ActiveRecord::Migration
  def self.up
    create_table :user_sets do |t|
      t.belongs_to :user
      t.belongs_to :set
      t.integer :chapter

      t.timestamps
    end
  end

  def self.down
    drop_table :user_sets
  end
end

# -*- encoding : utf-8 -*-
class CreateSets < ActiveRecord::Migration
  def self.up
    create_table :sets do |t|

      t.timestamps
    end

    create_table :set_names do |t|
      t.belongs_to :sets
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :set_names
    drop_table :sets
  end
end

# -*- encoding : utf-8 -*-
class AddTypeToIdiom < ActiveRecord::Migration
  def self.up
    add_column :idioms, :idiom_type, :string
  end

  def self.down
    remove_column :idioms, :idiom_type
  end
end

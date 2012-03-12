# -*- encoding : utf-8 -*-
class AddEnabledToLanguage < ActiveRecord::Migration
  def self.up
    add_column :languages, :enabled, :boolean, :default => true
  end

  def self.down
    remove_column :languages, :enabled
  end
end

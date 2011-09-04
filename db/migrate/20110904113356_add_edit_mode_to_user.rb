class AddEditModeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :edit_mode, :boolean, :default => false
  end

  def self.down
    remove_column :users, :edit_mode
  end
end

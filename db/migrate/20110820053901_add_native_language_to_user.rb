class AddNativeLanguageToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :native_language_id, :integer

    User.migrate_all_users_without_language_to_english
  end

  def self.down
    remove_column :users, :native_language_id
  end
end

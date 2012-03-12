# -*- encoding : utf-8 -*-
class AddLanguageReferenceToTranslation < ActiveRecord::Migration
  def self.up
    add_column :translations, :language_id, :integer
    remove_column :translations, :language
  end

  def self.down
    remove_column :translations, :language_id
    add_column :translations, :language, :string
  end
end

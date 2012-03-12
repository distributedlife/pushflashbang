# -*- encoding : utf-8 -*-
class AddTypeToTranslation < ActiveRecord::Migration
  def self.up
    add_column :translations, :t_type, :string
  end

  def self.down
    remove_column :translations, :t_type
  end
end

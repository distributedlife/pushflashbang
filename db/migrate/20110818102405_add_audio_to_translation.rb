# -*- encoding : utf-8 -*-
class AddAudioToTranslation < ActiveRecord::Migration
  def self.up
    add_column :translations, :audio_file_name, :string
  end

  def self.down
    remove_column :translations, :audio_file_name
  end
end

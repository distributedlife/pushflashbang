# -*- encoding : utf-8 -*-
class AddAudioToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :audio_file_name, :string
  end

  def self.down
    remove_column :cards, :audio_file_name
  end
end

class AddAudioToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :audio_url, :string
  end

  def self.down
    remove_column :cards, :audio_url
  end
end

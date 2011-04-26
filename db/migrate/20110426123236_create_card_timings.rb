class CreateCardTimings < ActiveRecord::Migration
  def self.up
    create_table :card_timings do |t|
      t.integer :seconds

      t.timestamps
    end
  end

  def self.down
    drop_table :card_timings
  end
end

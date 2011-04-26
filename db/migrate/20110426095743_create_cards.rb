class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.text :front
      t.text :back
      t.belongs_to :deck

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end

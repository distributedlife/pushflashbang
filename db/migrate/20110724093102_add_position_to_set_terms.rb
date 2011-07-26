class AddPositionToSetTerms < ActiveRecord::Migration
  def self.up
    add_column :set_terms, :position, :integer
  end

  def self.down
    remove_column :set_terms, :position
  end
end

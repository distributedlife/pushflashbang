class CreateSetTerms < ActiveRecord::Migration
  def self.up
    create_table :set_terms do |t|
      t.references :set
      t.references :term
      
      t.timestamps
    end
  end

  def self.down
    drop_table :set_terms
  end
end

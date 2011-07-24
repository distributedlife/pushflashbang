class AddChapterToSetTerms < ActiveRecord::Migration
  def self.up
    add_column :set_terms, :chapter, :integer

    execute <<-SQL
      UPDATE set_terms
      SET chapter = 1
    SQL
  end

  def self.down
    remove_column :set_terms, :chapter
  end
end

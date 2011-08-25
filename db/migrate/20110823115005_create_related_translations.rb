class CreateRelatedTranslations < ActiveRecord::Migration
  def self.up
    create_table :related_translations do |t|
      t.integer :translation1_id
      t.integer :translation2_id
      t.boolean :share_written_form
      t.boolean :share_audible_form
      t.boolean :share_meaning

      t.timestamps
    end
  end

  def self.down
    drop_table :related_translations
  end
end

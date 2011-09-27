class DropIdiomTranslation < ActiveRecord::Migration
  def self.up
    drop_table :idiom_translations
  end

  def self.down
  end
end

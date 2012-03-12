# -*- encoding : utf-8 -*-
class DeleteIdiomTranslations < ActiveRecord::Migration
  def self.up
    drop_table :idiom_translations
  end

  def self.down
    create_table :idiom_translations do |t|
      t.references :idiom
      t.references :translation

      t.timestamps
    end
  end
end

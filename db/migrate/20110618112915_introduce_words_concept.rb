class IntroduceWordsConcept < ActiveRecord::Migration
  def self.up
    create_table :idioms do |t|
    end

    create_table :idiom_translations do |t|
      t.references :idiom
      t.references :translation
      
      t.timestamps
    end

    create_table :translations do |t|
      t.text :language
      t.text :form
      t.text :pronunciation

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
    drop_table :idiom_translations
    drop_table :idioms
  end
end

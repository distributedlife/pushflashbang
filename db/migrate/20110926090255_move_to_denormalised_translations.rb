class MoveToDenormalisedTranslations < ActiveRecord::Migration
  def self.up
    # add idiom to translation
    add_column :translations, :idiom_id, :integer

    Delayed::Job.enqueue DenormaliseTranslationsJob.new
  end

  def self.down
    remove_column :translations, :idiom_id
  end
end

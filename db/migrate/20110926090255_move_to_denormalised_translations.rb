class MoveToDenormalisedTranslations < ActiveRecord::Migration
  def self.up
    # add idiom to translation
    add_column :translations, :idiom_id, :integer

    step_size = 20000
    (1 .. 499_999).step(step_size) do |i|
      Delayed::Job.enqueue DenormaliseTranslationsJob.new(i, i + step_size)
    end
  end

  def self.down
    remove_column :translations, :idiom_id
  end
end

class Language < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  def self.get_or_create name
    language = Language.where(:name => name)
    if language.empty?
      language = Language.create(:name => name)
    else
      language = language.first
    end

    language
  end
end

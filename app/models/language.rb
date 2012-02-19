class Language < ActiveRecord::Base
  attr_accessible :name, :enabled

  validates :name, :presence => true

  scope :only_enabled, where(:enabled => true)

  def self.all
    return self.only_enabled
  end

  def self.get_or_create name
    language = Language.where(:name => name)
    if language.empty?
      puts "Creating language #{name}"
      language = Language.create(:name => name)
    else
      language = language.first
    end

    language
  end

  def enabled?
    return enabled
  end

  def disable!
    self.enabled = false
    self.save!
  end

  def supports_set? set_id
    SetTerms.where(:set_id => set_id).each do |set_terms|
      return !Translation.where(:language_id => self.id, :idiom_id => set_terms.term_id).empty?
    end
  end
end

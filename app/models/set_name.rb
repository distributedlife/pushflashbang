class SetName < ActiveRecord::Base
  attr_accessible :name, :description, :sets_id

  validates :sets_id, :presence => true
  validates :name, :presence => true

  belongs_to :sets

  def self.exists? set_id, set_name_id
    begin
      # set name exists
      set_name = SetName.find(set_name_id)

      # and set name belongs to set
      return set_name.sets_id == set_id.to_i
    rescue
      false
    end
  end
end

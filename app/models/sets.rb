class Sets < ActiveRecord::Base
  has_many :set_name

  def delete
    SetName.where(:sets_id => self.id).each do |set_name|
      set_name.delete
    end

    return super
  end
end

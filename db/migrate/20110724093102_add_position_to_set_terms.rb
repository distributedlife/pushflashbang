class AddPositionToSetTerms < ActiveRecord::Migration
  def self.up
    add_column :set_terms, :position, :integer

    current_set_term = 0
    current_position = 1
    SetTerms.group(:set_id).all.each do |set_term|
      if current_set_term != set_term.set_id
        current_position = 1
        current_set_term = set_term.set_id
      end

      set_term.position = current_position
      current_position = current_position + 1
    end
  end

  def self.down
    remove_column :set_terms, :position
  end
end

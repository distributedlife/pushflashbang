require 'spec_helper'

describe SetName do
  context 'to be valid' do
    it 'must be belong to a set' do
      set_name = SetName.create(:name => 'greetings')

      set_name.valid?.should be false
      set_name.sets_id = 1
      set_name.valid?.should be true
    end

    it 'requires a name' do
      set_name = SetName.create(:sets_id => 1)

      set_name.valid?.should be false
      set_name.name = "greetings"
      set_name.valid?.should be true
    end
  end
end

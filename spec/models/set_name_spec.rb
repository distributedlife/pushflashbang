# -*- encoding : utf-8 -*-
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

  context 'exists?' do
    before(:each) do
      @set = Sets.make!
      @set_name = SetName.make!(:sets_id => @set.id)
      @set_name2 = SetName.make!(:sets_id => 100)
    end

    it 'should return true if the set exists and belongs to the set' do
      SetName::exists?(@set.id, @set_name.id).should == true
    end

    it 'should return false if the set name does not exist' do
      SetName::exists?(@set.id, 100).should == false
    end

    it 'should return false if the set name does not belong to the set' do
      SetName::exists?(@set.id, @set_name2.id).should == false
    end
  end
end

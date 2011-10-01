require 'spec_helper'

describe ArrayHelper do
  context 'get_first' do
    it 'should return nil if object is not found' do
      get_first([]).nil?.should == true
    end

    it 'should return the element if found' do
      get_first(['a', 'b']).should == 'a'
    end
  end
end
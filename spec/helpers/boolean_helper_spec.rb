require 'spec_helper'

describe BooleanHelper do
  context 'to_boolean' do
    it 'should return true' do
      to_boolean(true).should == true
      to_boolean("true").should == true
      to_boolean("t").should == true
      to_boolean("t").should == true
      to_boolean("1").should == true
      to_boolean(1).should == true
      to_boolean("T").should == true
      to_boolean("Y").should == true
      to_boolean("").should == false
      to_boolean(false).should == false
      to_boolean("false").should == false
      to_boolean("f").should == false
      to_boolean("F").should == false
      to_boolean(0).should == false
      to_boolean("0").should == false
    end
  end
end
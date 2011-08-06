require 'spec_helper'

describe Translation do
  context 'to be valid' do
    it 'should require a form' do
      term = Translation.new(:language_id => 1)

      term.valid?.should == false
      term.form = "hello"
      term.valid?.should == true
    end

    it 'should require a language' do
      term = Translation.new(:form => "hello")

      term.valid?.should == false
      term.language_id = 1
      term.valid?.should == true
    end
  end
end

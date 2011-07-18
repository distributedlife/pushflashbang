require 'spec_helper'

describe IdiomTranslation do
  context 'to be valid' do
    it 'should require an idiom_id' do
      term = IdiomTranslation.new(:translation_id => 1)

      term.valid?.should == false
      term.idiom_id = 3
      term.valid?.should == true
    end

    it 'should require a translation_id' do
      term = IdiomTranslation.new(:idiom_id => 1)

      term.valid?.should == false
      term.translation_id = 3
      term.valid?.should == true
    end
  end
end

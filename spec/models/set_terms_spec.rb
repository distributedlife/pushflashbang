require 'spec_helper'

describe SetTerms do
  context 'to be valid' do
    it 'should have a set id' do
      set_term = SetTerms.new(:term_id => 1)
      set_term.valid?.should be false
      set_term.set_id = 2
      set_term.valid?.should be true
    end

    it 'should have a term id' do
      set_term = SetTerms.new(:set_id => 1)
      set_term.valid?.should be false
      set_term.term_id = 2
      set_term.valid?.should be true
    end
  end
end

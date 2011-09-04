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

  describe 'translations_share_idiom?' do
    before(:each) do
      idiom = Idiom.make
      @t1 = Translation.make
      @t2 = Translation.make
      @t3 = Translation.make

      add_translation_to_idiom idiom.id, @t1.id
      add_translation_to_idiom idiom.id, @t2.id
    end

    it 'should return true if two translations share an idiom' do
      IdiomTranslation::translations_share_idiom?(@t1, @t2).should be true
      IdiomTranslation::translations_share_idiom?(@t2, @t1).should be true
    end

    it 'should return false if two translations do not share an idiom' do
      IdiomTranslation::translations_share_idiom?(@t1, @t3).should be false
    end
  end
end

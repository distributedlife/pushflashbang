require 'spec_helper'

describe Idiom do
  describe 'translations_in_idiom_and_language' do
    before(:each) do
      @english = Language.make
      @chinese = Language.make
      @spanish = Language.make

      @idiom = Idiom.create
      @translation1 = Translation.create(:language_id => @english.id, :form => "a")
      @translation2 = Translation.create(:language_id => @chinese.id, :form => "b")
      @translation3 = Translation.create(:language_id => @chinese.id, :form => "c")

      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation1.id)
      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation2.id)
      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation3.id)
    end

    it 'should return an empty set if no translations are in the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @spanish.id).should == []
    end

    it 'should return the translations that share the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @english.id).should == [@translation1]
      Idiom::translations_in_idiom_and_language(@idiom.id, @chinese.id).should == [@translation2, @translation3]
    end
  end
end
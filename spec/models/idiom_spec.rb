require 'spec_helper'

describe Idiom do
  describe 'translations_in_idiom_and_language' do
    before(:each) do
      @english = Language.make!
      @chinese = Language.make!
      @spanish = Language.make!

      @idiom = Idiom.create
      @translation1 = Translation.create(:idiom_id => @idiom.id, :language_id => @english.id, :form => "a")
      @translation2 = Translation.create(:idiom_id => @idiom.id, :language_id => @chinese.id, :form => "b")
      @translation3 = Translation.create(:idiom_id => @idiom.id, :language_id => @chinese.id, :form => "c")
    end

    it 'should return an empty set if no translations are in the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @spanish.id).should == []
    end

    it 'should return the translations that share the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @english.id).should == [@translation1]
      Idiom::translations_in_idiom_and_language(@idiom.id, @chinese.id).should == [@translation2, @translation3]
    end
  end

  describe 'exists?' do
    it 'should return true if the idiom exists' do
      Idiom::exists?(Idiom.make!.id).should == true
    end

    it 'should return false if the idiom does not exist' do
      Idiom::exists?(100).should == false
    end
  end

  describe 'get_from_translations' do
    before(:each) do
      @idiom = Idiom.make!
      @idiom2 = Idiom.make!
      @t = Translation.make!(:idiom_id => @idiom.id)
      @t2 = Translation.make!(:idiom_id => @idiom2.id)
      @t3 = Translation.make!(:idiom_id => @idiom2.id)
    end

    it 'should return the idiom refered by the translation' do
      result = Idiom::get_from_translations @t

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should return the idioms refered by multiple translations' do
      result = Idiom::get_from_translations [@t, @t2]

      result.count.should == 2

      result.should == [@idiom, @idiom2]
    end
    
    it 'should accept translation ids' do
      result = Idiom::get_from_translations @t.id

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should accept translation objects' do
      result = Idiom::get_from_translations @t

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should return each idiom only once' do
      result = Idiom::get_from_translations [@t, @t2, @t3]

      result.count.should == 2

      result.should == [@idiom, @idiom2]
    end
  end
end

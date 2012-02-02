require 'spec_helper'

describe TranslationHelper do
  context 'all_translations_sorted_correctly' do
    it 'should return translations sorted by idiom, language name and then form' do
      l1 = Language.make!(:name => "a")
      l2 = Language.make!(:name => "b")

      Translation.delete_all
      
      t1 = Translation.make!(:idiom_id => 1, :language_id => l1.id, :form => "a")
      t2 = Translation.make!(:idiom_id => 1, :language_id => l2.id, :form => "a")
      t3 = Translation.make!(:idiom_id => 1, :language_id => l2.id, :form => "b")
      t4 = Translation.make!(:idiom_id => 2, :language_id => l1.id, :form => "a")
      t5 = Translation.make!(:idiom_id => 2, :language_id => l2.id, :form => "a")
      t6 = Translation.make!(:idiom_id => 2, :language_id => l2.id, :form => "b")

      
      set = all_translations_sorted_correctly
      set[0].should == t1
      set[1].should == t2
      set[2].should == t3
      set[3].should == t4
      set[4].should == t5
      set[5].should == t6
    end
  end

  context 'all_translations_sorted_correctly_for_idiom' do
    it 'should return translations sorted by language name and then form' do
      l1 = Language.make!(:name => "a")
      l2 = Language.make!(:name => "b")

      Translation.delete_all

      t1 = Translation.make!(:idiom_id => 1, :language_id => l1.id, :form => "a")
      t2 = Translation.make!(:idiom_id => 1, :language_id => l2.id, :form => "a")
      t3 = Translation.make!(:idiom_id => 1, :language_id => l2.id, :form => "b")
      t4 = Translation.make!(:idiom_id => 2, :language_id => l1.id, :form => "a")
      t5 = Translation.make!(:idiom_id => 2, :language_id => l2.id, :form => "a")
      t6 = Translation.make!(:idiom_id => 2, :language_id => l2.id, :form => "b")


      set = all_translations_sorted_correctly_for_idiom 1

      set[0].should == t1
      set[1].should == t2
      set[2].should == t3
    end
  end

  context 'translation_exists?' do
    it 'should return true if a translation exists' do
      a = Translation.make!

      translation_exists?(a.id).should == true
    end

    it 'should return false if no translation exists' do
      translation_exists?(1).should == false
    end
  end
end
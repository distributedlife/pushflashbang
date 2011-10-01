require 'spec_helper'

describe Sets do
  context 'exists?' do
    it 'should return true if the set exists' do
      Sets::exists?(Sets.make.id).should == true
    end

    it 'should return false if the set does not exist' do
      Sets::exists?(100).should == false
    end
  end

  context 'add_term' do
    before(:each) do
      @idiom = Idiom.make
      @set = Sets.make

      SetTerms.create(:set_id => @set.id, :term_id => 100, :chapter => 1, :position => 1)
      SetTerms.create(:set_id => @set.id, :term_id => 101, :chapter => 1, :position => 2)
      SetTerms.create(:set_id => @set.id, :term_id => 102, :chapter => 2, :position => 3)
    end

    it 'should add the term to the last chapter' do
      @set.add_term @idiom.id

      SetTerms.count.should == 4
      SetTerms.where(:set_id => @set.id, :term_id => @idiom.id).first.chapter.should == 2
    end

    it 'should add the term to the last position' do
      @set.add_term @idiom.id

      SetTerms.count.should == 4
      SetTerms.where(:set_id => @set.id, :term_id => @idiom.id).first.position.should == 4
    end

    it 'should not a term already in the set' do
      @set.add_term @idiom.id
      SetTerms.count.should == 4

      @set.add_term @idiom.id
      SetTerms.count.should == 4
    end
  end

  context 'has_at_least_one_idiom_for_language' do
    before(:each) do
      @idiom1 = Idiom.make
      @idiom2 = Idiom.make
      @language1 = Language.make
      @language2 = Language.make
      @translation1 = Translation.make(:idiom_id => @idiom1.id, :language_id => @language1.id)
      @translation2 = Translation.make(:idiom_id => @idiom2.id, :language_id => @language2.id)
      @set = Sets.make
      @set.add_term @idiom1.id
    end

    it 'should return false if set does not have an idiom in langauge' do
      @set.has_at_least_one_idiom_for_language(@language2.id).should == false
    end

    it 'should return false if set does have an idiom in language' do
      @set.has_at_least_one_idiom_for_language(@language1.id).should == true
    end
  end
end

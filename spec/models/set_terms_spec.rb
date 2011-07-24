require 'spec_helper'

describe SetTerms do
  context 'to be valid' do
    it 'should have a set id' do
      set_term = SetTerms.new(:term_id => 1, :chapter => 1, :position => 1)
      set_term.valid?.should be false
      set_term.set_id = 2
      set_term.valid?.should be true
    end

    it 'should have a term id' do
      set_term = SetTerms.new(:set_id => 1, :chapter => 1, :position => 1)
      set_term.valid?.should be false
      set_term.term_id = 2
      set_term.valid?.should be true
    end

    it 'should have a chapter' do
      set_term = SetTerms.new(:set_id => 1, :term_id => 1, :position => 1)
      set_term.valid?.should be false
      set_term.chapter = 1
      set_term.valid?.should be true
    end
    
    it 'should have a position' do
      set_term = SetTerms.new(:set_id => 1, :term_id => 1, :chapter => 1)
      set_term.valid?.should be false
      set_term.position = 1
      set_term.valid?.should be true
    end
  end

  context 'increment_chapter_for_set' do
    it 'should increment all chapters for set' do
      SetTerms.make(:set_id => 1, :term_id => 2, :chapter => 0)
      SetTerms.make(:set_id => 1, :term_id => 3, :chapter => 1)
      SetTerms.make(:set_id => 1, :term_id => 4, :chapter => 2)

      SetTerms::increment_chapters_for_set 1

      SetTerms.where(:set_id => 1, :term_id => 2).first.chapter.should == 1
      SetTerms.where(:set_id => 1, :term_id => 3).first.chapter.should == 2
      SetTerms.where(:set_id => 1, :term_id => 4).first.chapter.should == 3

    end

    it 'should not touch other chapters' do
      SetTerms.make(:set_id => 2, :term_id => 5, :chapter => 1)

      SetTerms::increment_chapters_for_set 1
      
      SetTerms.where(:set_id => 2, :term_id => 5).first.chapter.should == 1
    end
  end

  context 'decrement_chapters_for_set_after_chapter' do
    it 'should decrement all chapters for set except those equal to or below chapter' do
      SetTerms.make(:set_id => 1, :term_id => 2, :chapter => 1)
      SetTerms.make(:set_id => 1, :term_id => 3, :chapter => 2)
      SetTerms.make(:set_id => 1, :term_id => 4, :chapter => 3)

      SetTerms::decrement_chapters_for_set_after_chapter 1, 2

      SetTerms.where(:set_id => 1, :term_id => 2).first.chapter.should == 1
      SetTerms.where(:set_id => 1, :term_id => 3).first.chapter.should == 2
      SetTerms.where(:set_id => 1, :term_id => 4).first.chapter.should == 2

    end

    it 'should not touch other chapters' do
      SetTerms.make(:set_id => 2, :term_id => 5, :chapter => 1)

      SetTerms::decrement_chapters_for_set_after_chapter 1, 2

      SetTerms.where(:set_id => 2, :term_id => 5).first.chapter.should == 1
    end
  end
end

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RelatedTranslations do
  describe 'to be valid' do
    it 'requires all both translation properties' do
      rt = RelatedTranslations.new(:translation1_id => 1, :translation2_id => 2, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be true

      rt = RelatedTranslations.new(:translation2_id => 2, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be false

      rt = RelatedTranslations.new(:translation1_id => 1, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be false
    end
  end

  describe 'get_relationship' do
    before(:each) do
      idiom = Idiom.make!
      idiom2 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t3 = Translation.make!(:idiom_id => idiom2.id, :language_id => 1)

      relate_translation_to_others @t1.id, idiom.id
      relate_translation_to_others @t2.id, idiom.id
    end

    it 'should return the relationship between two translations' do
      rt1 = RelatedTranslations::get_relationship @t1.id, @t2.id
      rt2 = RelatedTranslations::get_relationship @t2.id, @t1.id

      rt1.translation1_id.should == rt2.translation2_id
      rt1.translation2_id.should == rt2.translation1_id
      rt1.should == RelatedTranslations.where(:translation1_id => @t1.id, :translation2_id => @t2.id).first
    end

    it 'should return nil if there is no relationship' do
      RelatedTranslations::get_relationship(@t1.id, @t3.id).nil?.should be true
    end
  end

  describe 'delete_relationships_for_transation' do
    before(:each) do
      idiom = Idiom.make!
      idiom2 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t3 = Translation.make!(:idiom_id => idiom2.id, :language_id => 1)

      relate_translation_to_others @t1.id, idiom.id
      relate_translation_to_others @t2.id, idiom.id
      
    end

    it 'should delete a relationship if it exists' do
      RelatedTranslations::get_relationship(@t1.id, @t2.id).nil?.should be false
      RelatedTranslations::get_relationship(@t2.id, @t1.id).nil?.should be false

      RelatedTranslations::delete_relationships_for_translation @t1

      RelatedTranslations::get_relationship(@t1.id, @t2.id).nil?.should be true
      RelatedTranslations::get_relationship(@t2.id, @t1.id).nil?.should be true
    end
  end

  describe 'rebuild_relationships_for_translation' do
    before(:each) do
      idiom = Idiom.make!
      idiom2 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t3 = Translation.make!(:idiom_id => idiom2.id, :language_id => 1)

      RelatedTranslations.make!(:translation1_id => @t1.id, :translation2_id => @t2.id, :share_meaning => false, :share_written_form => true, :share_audible_form => true)
    end

    it 'should delete relationships that no longer apply' do
      RelatedTranslations::rebuild_relationships_for_translation @t1
      
      RelatedTranslations::get_relationship(@t1.id, @t3.id).nil?.should be true
    end

    it 'should create relationships that now exist' do
      RelatedTranslations::rebuild_relationships_for_translation @t1

      RelatedTranslations::get_relationship(@t1.id, @t2.id).nil?.should be false
      RelatedTranslations::get_relationship(@t2.id, @t1.id).nil?.should be false
    end
  end

  describe 'create_relationships_for_translation' do
    before(:each) do
      idiom = Idiom.make!
      idiom2 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t3 = Translation.make!(:idiom_id => idiom2.id, :language_id => 1)
    end

    it 'should create relationships that now exist' do
      RelatedTranslations::create_relationships_for_translation @t1

      RelatedTranslations::get_relationship(@t1.id, @t2.id).nil?.should be false
      RelatedTranslations::get_relationship(@t2.id, @t1.id).nil?.should be false
    end
  end

  describe 'create_relationship_if_needed' do
    before(:each) do
      idiom = Idiom.make!
      idiom2 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => 1)
      @t3 = Translation.make!(:idiom_id => idiom2.id, :language_id => 1)
    end

    it 'should create a relationship if one is needed' do
      RelatedTranslations::create_relationship_if_needed @t1, @t2

      RelatedTranslations::get_relationship(@t1.id, @t2.id).nil?.should be false
      RelatedTranslations::get_relationship(@t2.id, @t1.id).nil?.should be false
    end

    it 'should not create relationships where one is not needed' do
      RelatedTranslations::create_relationship_if_needed @t1, @t3

      RelatedTranslations::get_relationship(@t1.id, @t3.id).nil?.should be true
      RelatedTranslations::get_relationship(@t3.id, @t1.id).nil?.should be true
    end
  end

  describe 'get_related' do
    before(:each) do
      @user = User.make!
      @user2 = User.make!
      @chinese = Language.make!
      @spanish = Language.make!
      # 1,2 share meaning
      # 3,5 share meaning
      # 1,3 share written form
      # 2,5 share audible form
      @idiom1 = Idiom.make!
      @t1 = Translation.make!(:idiom_id => @idiom1.id, :language_id => @chinese.id, :form => "a")
      @t2 = Translation.make!(:idiom_id => @idiom1.id, :language_id => @chinese.id, :pronunciation => "p")
      @t3 = Translation.make!(:idiom_id => @idiom1.id, :language_id => @spanish.id)
      relate_translation_to_others @t1.id, @idiom1.id
      relate_translation_to_others @t2.id, @idiom1.id
      relate_translation_to_others @t3.id, @idiom1.id

      @idiom2 = Idiom.make!
      @t4 = Translation.make!(:idiom_id => @idiom2.id, :language_id => @chinese.id, :form => "a")
      @t5 = Translation.make!(:idiom_id => @idiom2.id, :language_id => @chinese.id, :pronunciation => "p")

      relate_translation_to_others @t4.id, @idiom2.id
      relate_translation_to_others @t5.id, @idiom2.id

      user_has_reviewed_idiom @idiom1.id, @chinese.id, @user.id
    end

    it 'should not find relationships to idioms the user has not learnt yet' do
      related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id

      element_is_in_set?(@t1.id, related).should be true
      element_is_in_set?(@t2.id, related).should be true
      element_is_in_set?(@t4.id, related).should be false


      user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id
      related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id

      element_is_in_set?(@t4.id, related).should be true
    end

    it 'will not find relationships in other languages' do
      user_has_reviewed_idiom @idiom1.id, @chinese.id, @user.id

      related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id

      element_is_in_set?(@t3.id, related).should be false
    end
    
    it 'will not find relationships for other users' do
      user_has_reviewed_idiom @idiom2.id, @chinese.id, @user2.id

      related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id

      element_is_in_set?(@t4.id, related).should be false
    end

    it 'will find relationships for multiple source translations' do
      user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id
      
      related = RelatedTranslations::get_related [@t1.id, @t2.id], @user.id, @chinese.id

      element_is_in_set?(@t1.id, related).should be true
      element_is_in_set?(@t2.id, related).should be true
      element_is_in_set?(@t4.id, related).should be true
      element_is_in_set?(@t5.id, related).should be true
    end

    describe 'by default' do
      it 'should find words related either meaning, form or pronunciation' do
        user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

        related = RelatedTranslations::get_related [@t1.id, @t2.id], @user.id, @chinese.id

        element_is_in_set?(@t1.id, related).should be true
        element_is_in_set?(@t2.id, related).should be true
        element_is_in_set?(@t4.id, related).should be true
        element_is_in_set?(@t5.id, related).should be true
      end
    end

    describe 'when meaning' do
      describe 'is true' do
        it 'will only returns translations that share at least meaning' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id, {:meaning => true}

          element_is_in_set?(@t1.id, related).should be true
          element_is_in_set?(@t2.id, related).should be true
          element_is_in_set?(@t4.id, related).should be false
        end
      end

      describe 'is false' do
        it 'will only return translations that do not share meaning' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id, {:meaning => false}

          element_is_in_set?(@t1.id, related).should be true
          element_is_in_set?(@t2.id, related).should be false
          element_is_in_set?(@t4.id, related).should be true
        end
      end
    end

    describe 'when written form' do
      describe 'is true' do
        it 'will only returns translations that share at least written form' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id, {:written => true}

          element_is_in_set?(@t1.id, related).should be true
          element_is_in_set?(@t2.id, related).should be false
          element_is_in_set?(@t4.id, related).should be true
        end
      end

      describe 'is false' do
        it 'will only return translations that do not share meaning' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t1.id], @user.id, @chinese.id, {:written => false}

          element_is_in_set?(@t1.id, related).should be true
          element_is_in_set?(@t2.id, related).should be true
          element_is_in_set?(@t4.id, related).should be false
        end
      end
    end

    describe 'when audible form' do
      describe 'is true' do
        it 'will only returns translations that share at least audible form' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t2.id], @user.id, @chinese.id, {:audible => true}

          element_is_in_set?(@t1.id, related).should be false
          element_is_in_set?(@t2.id, related).should be true
          element_is_in_set?(@t5.id, related).should be true
        end
      end

      describe 'is false' do
        it 'will only return translations that do not share meaning' do
          user_has_reviewed_idiom @idiom2.id, @chinese.id, @user.id

          related = RelatedTranslations::get_related [@t2.id], @user.id, @chinese.id, {:audible => false}

          element_is_in_set?(@t1.id, related).should be true
          element_is_in_set?(@t2.id, related).should be true
          element_is_in_set?(@t5.id, related).should be false
        end
      end
    end
  end
end

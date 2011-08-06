require 'spec_helper'

describe TranslationsController do
  context '"DELETE" destroy' do
    before(:each) do
      @user = User.make
      sign_in :user, @user

      @idiom = Idiom.make
      @translation1 = Translation.make
      @translation2 = Translation.make
      @translation3 = Translation.make
      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation1.id)
      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation2.id)
      IdiomTranslation.create(:idiom_id => @idiom.id, :translation_id => @translation3.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should delete the supplied translation if it exists' do
      delete :destroy, :term_id => @idiom.id, :id => @translation1.id

      Translation.where(:id => @translation1.id).empty?.should be true
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation1.id).empty?.should be true
      Translation.where(:id => @translation2.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation2.id).empty?.should be false
      Translation.where(:id => @translation3.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation3.id).empty?.should be false

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
    end

    it 'should not delete a translation the belongs to a term with a total of two translations' do
      delete :destroy, :term_id => @idiom.id, :id => @translation1.id
      delete :destroy, :term_id => @idiom.id, :id => @translation2.id

      Translation.where(:id => @translation1.id).empty?.should be true
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation1.id).empty?.should be true
      Translation.where(:id => @translation2.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation2.id).empty?.should be false
      Translation.where(:id => @translation3.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom.id, :translation_id => @translation3.id).empty?.should be false

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
    end

    it 'should redirect to back' do
      delete :destroy, :term_id => @idiom.id, :id => @translation1.id

      response.should be_redirect
      response.should redirect_to(:back)
    end
  end

  context '"POST" attach_and_detach' do
    before(:each) do
      @user = User.make
      sign_in :user, @user

      @idiom1 = Idiom.make
      @idiom2 = Idiom.make
      @translation1 = Translation.make
      @translation2 = Translation.make
      @translation3 = Translation.make
      @translation4 = Translation.make
      @translation5 = Translation.make
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation1.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation2.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation3.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation4.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation5.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should link the translation id to the specified idiom id' do
      post :attach_and_detach, :term_id => @idiom2.id, :id => @translation3.id, :remove_from_idiom_id => @idiom1.id

      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation1.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation2.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation3.id).empty?.should be true
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation3.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation4.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation5.id).empty?.should be false
    end
  end

  context '"GET" select' do
    before(:each) do
      @user = User.make
      sign_in :user, @user

      @idiom1 = Idiom.make
      @idiom2 = Idiom.make
      english = Language.make(:name => "English")
      spanish = Language.make(:name => "Spanish")
      chinese = Language.make(:name => "Chinese")
      @translation1 = Translation.make(:language_id => english.id, :form => "Zebra")
      @translation2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      @translation3 = Translation.make(:language_id => chinese.id, :form => "ce")
      @translation4 = Translation.make(:language_id => english.id, :form => "Hobo")
      @translation5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation1.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation2.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation3.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation4.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation5.id)
    end

    it 'should not return translations in the specifid idiom' do
      get :select, :term_id => @idiom2.id

      assigns[:translations][0].idiom_translations.idiom_id.should == @idiom1.id
      assigns[:translations][0].id.should == @translation3.id
      assigns[:translations][1].idiom_translations.idiom_id.should == @idiom1.id
      assigns[:translations][1].id.should == @translation1.id
      assigns[:translations][2].idiom_translations.idiom_id.should == @idiom1.id
      assigns[:translations][2].id.should == @translation2.id

      assigns[:translations].count.should == 3
    end
  end

  context '"POST" attach' do
    before(:each) do
      @user = User.make
      sign_in :user, @user

      @idiom1 = Idiom.make
      @idiom2 = Idiom.make
      @translation1 = Translation.make
      @translation2 = Translation.make
      @translation3 = Translation.make
      @translation4 = Translation.make
      @translation5 = Translation.make
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation1.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation2.id)
      IdiomTranslation.create(:idiom_id => @idiom1.id, :translation_id => @translation3.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation4.id)
      IdiomTranslation.create(:idiom_id => @idiom2.id, :translation_id => @translation5.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should link the translation id to the specified idiom id' do
      post :attach, :term_id => @idiom2.id, :id => @translation3.id

      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation1.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation2.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom1.id, :translation_id => @translation3.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation3.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation4.id).empty?.should be false
      IdiomTranslation.where(:idiom_id => @idiom2.id, :translation_id => @translation5.id).empty?.should be false
    end
  end
end

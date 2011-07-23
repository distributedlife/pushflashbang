require 'spec_helper'

describe TermsController do
  context '"GET" index' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return all terms grouped by idiom and order by language and form' do
      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :index

      assigns[:idiom_translations][0].idiom_id.should == idiom1.id
      assigns[:idiom_translations][0].translation.language.should == "Chinese"
      assigns[:idiom_translations][0].translation.form.should == "ce"

      assigns[:idiom_translations][1].idiom_id.should == idiom1.id
      assigns[:idiom_translations][1].translation.language.should == "English"
      assigns[:idiom_translations][1].translation.form.should == "Zebra"

      assigns[:idiom_translations][2].idiom_id.should == idiom1.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Cabron"


      assigns[:idiom_translations][3].idiom_id.should == idiom2.id
      assigns[:idiom_translations][3].translation.language.should == "English"
      assigns[:idiom_translations][3].translation.form.should == "Hobo"

      assigns[:idiom_translations][4].idiom_id.should == idiom2.id
      assigns[:idiom_translations][4].translation.language.should == "Spanish"
      assigns[:idiom_translations][4].translation.form.should == "Abanana"

      assigns[:idiom_translations][5].idiom_id.should == idiom2.id
      assigns[:idiom_translations][5].translation.language.should == "Spanish"
      assigns[:idiom_translations][5].translation.form.should == "Allegra"
    end
  end

  context '"GET" new' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return two empty translation objects' do
      get :new

      assigns[:translations].count.should == 2
      assigns[:translations][0].id.nil?.should be true
      assigns[:translations][0].language.nil?.should be true
      assigns[:translations][0].form.nil?.should be true
      assigns[:translations][0].pronunciation.nil?.should be true
      assigns[:translations][1].id.nil?.should be true
      assigns[:translations][1].language.nil?.should be true
      assigns[:translations][1].form.nil?.should be true
      assigns[:translations][1].pronunciation.nil?.should be true
    end
  end

  context '"POST" create' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should notify user that two valid translations need to be provided' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0


      post :create, :translation =>
        {
          "0" => {
            :language => "alang",
            :form => "atrans",
            :pronunciation => "apro"
          }
        }


      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      flash[:failure].should == "At least two translations need to be supplied"
    end

    it 'should require at least two valid objects to be a success' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      
      post :create, :translation =>
        {
          "0" => {
            :language => "alang",
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language => "blang",
            :form => "btrans",
            :pronunciation => "bpro"
          }
        }

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
      Idiom.count.should == 1

      idiom = Idiom.first
      translations = IdiomTranslation.joins(:translation).order(:language, :form, :pronunciation).all

      translations[0].idiom_id.should == idiom.id
      translations[0].translation.language.should == "alang"
      translations[0].translation.form.should == "atrans"
      translations[0].translation.pronunciation.should == "apro"
      translations[1].idiom_id.should == idiom.id
      translations[1].translation.language.should == "blang"
      translations[1].translation.form.should == "btrans"
      translations[1].translation.pronunciation.should == "bpro"
    end

    it 'should ignore completely empty objects' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      post :create, :translation =>
        {
          "0" => {
            :language => "alang",
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language => "blang",
            :form => "btrans",
            :pronunciation => "bpro"
          },
          "2" => {
            :language => "",
            :form => "",
            :pronunciation => ""
          },
          "3" => {
            :language => nil,
            :form => nil,
            :pronunciation => nil
          }
        }

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
      Idiom.count.should == 1

      idiom = Idiom.first
      translations = IdiomTranslation.joins(:translation).order(:language, :form, :pronunciation).all

      translations[0].idiom_id.should == idiom.id
      translations[0].translation.language.should == "alang"
      translations[0].translation.form.should == "atrans"
      translations[0].translation.pronunciation.should == "apro"
      translations[1].idiom_id.should == idiom.id
      translations[1].translation.language.should == "blang"
      translations[1].translation.form.should == "btrans"
      translations[1].translation.pronunciation.should == "bpro"
    end

    it 'should fail on any incomplete objects' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      post :create, :translation =>
        {
          "0" => {
            :language => "alang",
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language => "blang",
            :form => "",
            :pronunciation => "bpro"
          }
        }

      Translation.count.should == 0
      IdiomTranslation.count.should == 0
      Idiom.count.should == 0

      flash[:failure].should == "All translations need to be complete"
    end
  end

  context '"GET" show' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return the idiom translation terms order by language and form' do
      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :show, :id => idiom1.id

      assigns[:idiom_translations][0].idiom_id.should == idiom1.id
      assigns[:idiom_translations][0].translation.language.should == "Chinese"
      assigns[:idiom_translations][0].translation.form.should == "ce"

      assigns[:idiom_translations][1].idiom_id.should == idiom1.id
      assigns[:idiom_translations][1].translation.language.should == "English"
      assigns[:idiom_translations][1].translation.form.should == "Zebra"

      assigns[:idiom_translations][2].idiom_id.should == idiom1.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Cabron"
    end

    it 'should redirect to the show all terms path if the idiom is not found' do
      get :show, :id => 100

      response.should be_redirect
      flash[:failure].should == "The term you were looking for no longer exists"
    end

    it 'should redirect to the show all terms path if the idiom has no translations' do
      idiom = Idiom.make

      get :show, :id => idiom.id
      
      flash[:failure].should == "The term you were looking has no translations"
    end
  end

  context '"GET" edit' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should redirect to the show all terms path if the idiom is not found' do
      get :edit, :id => 100

      response.should be_redirect
    end

    it 'should redirect to the show all terms path if the idiom has no translations' do
      idiom = Idiom.make

      get :edit, :id => idiom.id

      flash[:failure].should == "The term you were looking has no translations"
    end

    it 'should return the idiom translation terms order by language and form' do
      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :edit, :id => idiom1.id

      assigns[:idiom_translations][0].idiom_id.should == idiom1.id
      assigns[:idiom_translations][0].translation.language.should == "Chinese"
      assigns[:idiom_translations][0].translation.form.should == "ce"

      assigns[:idiom_translations][1].idiom_id.should == idiom1.id
      assigns[:idiom_translations][1].translation.language.should == "English"
      assigns[:idiom_translations][1].translation.form.should == "Zebra"

      assigns[:idiom_translations][2].idiom_id.should == idiom1.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Cabron"
    end
  end

  context '"PUT" update' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should update the translations' do
      idiom = Idiom.create
      translation1 = Translation.create(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.create(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language => "English Monkies",
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language => "Espanita",
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).language.should == "English Monkies"
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language.should == "Espanita"
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      IdiomTranslation.count.should == 2
    end

    it 'should notify user that two valid translations need to be provided' do
      idiom = Idiom.create
      translation1 = Translation.create(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.create(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language => "English Monkies",
            :form => "blag",
            :pronunciation => "wumpf"
          }
        }


      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).should == translation1
      Translation.find(translation2.id).should == translation2
      IdiomTranslation.count.should == 2

      flash[:failure].should == "At least two translations need to be supplied"
    end

    it 'should ignore completely empty objects' do
      idiom = Idiom.create
      translation1 = Translation.create(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.create(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language => "English Monkies",
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language => "Espanita",
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          },
          "2" => {
            :language => "",
            :form => "",
            :pronunciation => ""
          },
          "3" => {
            :language => nil,
            :form => nil,
            :pronunciation => nil
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).language.should == "English Monkies"
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language.should == "Espanita"
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      IdiomTranslation.count.should == 2
    end

    it 'should allow for the creation of new translations' do
      idiom = Idiom.create
      translation1 = Translation.create(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.create(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language => "English Monkies",
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language => "Espanita",
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          },
          "2" => {
            :language => "Chinese",
            :form => "ni hao",
            :pronunciation => "hello"
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 3
      Translation.find(translation1.id).language.should == "English Monkies"
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language.should == "Espanita"
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      Translation.last.language.should == "Chinese"
      Translation.last.form.should == "ni hao"
      Translation.last.pronunciation.should == "hello"
      IdiomTranslation.count.should == 3
    end

    it 'should fail on any incomplete objects' do
      idiom = Idiom.create
      translation1 = Translation.create(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.create(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language => "English Monkies",
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language => "Espanita",
            :form => "",
            :pronunciation => "wumpfitos"
          }
        }


      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).should == translation1
      Translation.find(translation2.id).should == translation2
      IdiomTranslation.count.should == 2

      flash[:failure].should == "All translations need to be complete"
    end
  end

  context '"POST" select' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return all terms grouped by idiom and order by language and form except the specified term' do
      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :select, :idiom_id => idiom1.id, :translation_id => term3.id
      

      assigns[:idiom_translations][0].idiom_id.should == idiom2.id
      assigns[:idiom_translations][0].translation.language.should == "English"
      assigns[:idiom_translations][0].translation.form.should == "Hobo"

      assigns[:idiom_translations][1].idiom_id.should == idiom2.id
      assigns[:idiom_translations][1].translation.language.should == "Spanish"
      assigns[:idiom_translations][1].translation.form.should == "Abanana"

      assigns[:idiom_translations][2].idiom_id.should == idiom2.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Allegra"
    end

    it 'should redirect to terms_path if the idiom does not exist' do
      idiom1 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)

      get :select, :idiom_id => 100, :translation_id => term3.id

      response.should be_redirect
      response.should redirect_to terms_path
    end

    it 'should redirect to terms_path if the translation does not exist' do
      idiom1 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)

      get :select, :idiom_id => idiom1.id, :translation_id => 100

      response.should be_redirect
      response.should redirect_to terms_path
    end
  end

  context '"GET" select_for_set' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return all terms grouped by idiom and order by language and form except the specified set' do
      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      set = Sets.create
      set_name = SetName.create(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      set_term = SetTerms.create(:set_id => set.id, :term_id => idiom1.id)

      get :select_for_set, :set_id => set.id


      assigns[:idiom_translations][0].idiom_id.should == idiom2.id
      assigns[:idiom_translations][0].translation.language.should == "English"
      assigns[:idiom_translations][0].translation.form.should == "Hobo"

      assigns[:idiom_translations][1].idiom_id.should == idiom2.id
      assigns[:idiom_translations][1].translation.language.should == "Spanish"
      assigns[:idiom_translations][1].translation.form.should == "Abanana"

      assigns[:idiom_translations][2].idiom_id.should == idiom2.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Allegra"
    end

    it 'should redirect to sets_path if the set does not exist' do
      get :select_for_set, :set_id => 100

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end
end

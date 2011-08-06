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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term4 = Translation.make(:language_id => english.id, :form => "Hobo")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      term6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :index

      assigns[:translations][0].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][0].language_id.should == chinese.id
      assigns[:translations][0].form.should == "ce"

      assigns[:translations][1].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][1].language_id.should == english.id
      assigns[:translations][1].form.should == "Zebra"

      assigns[:translations][2].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][2].language_id.should == spanish.id
      assigns[:translations][2].form.should == "Cabron"


      assigns[:translations][3].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][3].language_id.should == english.id
      assigns[:translations][3].form.should == "Hobo"

      assigns[:translations][4].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][4].language_id.should == spanish.id
      assigns[:translations][4].form.should == "Abanana"

      assigns[:translations][5].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][5].language_id.should == spanish.id
      assigns[:translations][5].form.should == "Allegra"
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
      assigns[:translations][0].language_id.nil?.should be true
      assigns[:translations][0].form.nil?.should be true
      assigns[:translations][0].pronunciation.nil?.should be true
      assigns[:translations][1].id.nil?.should be true
      assigns[:translations][1].language_id.nil?.should be true
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

      l = Language.make

      post :create, :translation =>
        {
          "0" => {
            :language_id => l.id,
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

      l = Language.make
      
      post :create, :translation =>
        {
          "0" => {
            :language_id => l.id,
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language_id => l.id,
            :form => "btrans",
            :pronunciation => "bpro"
          }
        }

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
      Idiom.count.should == 1

      idiom = Idiom.first
      translations = Translation.joins(:languages, :idiom_translations).order(:name, :form, :pronunciation).all

      translations[0].idiom_translations.idiom_id.should == idiom.id
      translations[0].language_id.should == l.id
      translations[0].form.should == "atrans"
      translations[0].pronunciation.should == "apro"
      translations[1].idiom_translations.idiom_id.should == idiom.id
      translations[1].language_id.should == l.id
      translations[1].form.should == "btrans"
      translations[1].pronunciation.should == "bpro"
    end

    it 'should ignore completely empty objects' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      l = Language.make

      post :create, :translation =>
        {
          "0" => {
            :language_id => l.id,
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language_id => l.id,
            :form => "btrans",
            :pronunciation => "bpro"
          },
          "2" => {
            :language_id => "",
            :form => "",
            :pronunciation => ""
          },
          "3" => {
            :language_id => nil,
            :form => nil,
            :pronunciation => nil
          }
        }

      Translation.count.should == 2
      IdiomTranslation.count.should == 2
      Idiom.count.should == 1

      idiom = Idiom.first
      translations = Translation.joins(:languages, :idiom_translations).order(:name, :form, :pronunciation).all

      translations[0].idiom_translations.idiom_id.should == idiom.id
      translations[0].language_id.should == l.id
      translations[0].form.should == "atrans"
      translations[0].pronunciation.should == "apro"
      translations[1].idiom_translations.idiom_id.should == idiom.id
      translations[1].language_id.should == l.id
      translations[1].form.should == "btrans"
      translations[1].pronunciation.should == "bpro"
    end

    it 'should fail on any incomplete objects' do
      Idiom.count.should == 0
      IdiomTranslation.count.should == 0
      Translation.count.should == 0

      l = Language.make

      post :create, :translation =>
        {
          "0" => {
            :language_id => l.id,
            :form => "atrans",
            :pronunciation => "apro"
          },
          "1" => {
            :language_id => l.id,
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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term4 = Translation.make(:language_id => english.id, :form => "Hobo")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      term6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :show, :id => idiom1.id

      assigns[:translations][0].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][0].language_id.should == chinese.id
      assigns[:translations][0].form.should == "ce"

      assigns[:translations][1].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][1].language_id.should == english.id
      assigns[:translations][1].form.should == "Zebra"

      assigns[:translations][2].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][2].language_id.should == spanish.id
      assigns[:translations][2].form.should == "Cabron"
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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term4 = Translation.make(:language_id => english.id, :form => "Hobo")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      term6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :edit, :id => idiom1.id

      assigns[:translations][0].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][0].language_id.should == chinese.id
      assigns[:translations][0].form.should == "ce"

      assigns[:translations][1].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][1].language_id.should == english.id
      assigns[:translations][1].form.should == "Zebra"

      assigns[:translations][2].idiom_translations.idiom_id.should == idiom1.id
      assigns[:translations][2].language_id.should == spanish.id
      assigns[:translations][2].form.should == "Cabron"
    end
  end

  context '"PUT" update' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should update the translations' do
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language_id => english.id,
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language_id => spanish.id,
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).language_id.should == english.id
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language_id.should == spanish.id
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      IdiomTranslation.count.should == 2
    end

    it 'should notify user that two valid translations need to be provided' do
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language_id => english.id,
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
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language_id => english.id,
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language_id => spanish.id,
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          },
          "2" => {
            :language_id => "",
            :form => "",
            :pronunciation => ""
          },
          "3" => {
            :language_id => nil,
            :form => nil,
            :pronunciation => nil
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 2
      Translation.find(translation1.id).language_id.should == english.id
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language_id.should == spanish.id
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      IdiomTranslation.count.should == 2
    end

    it 'should allow for the creation of new translations' do
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language_id => english.id,
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language_id => spanish.id,
            :form => "blagitos",
            :pronunciation => "wumpfitos"
          },
          "2" => {
            :language_id => chinese.id,
            :form => "ni hao",
            :pronunciation => "hello"
          }
        }

      Idiom.count.should == 1
      Translation.count.should == 3
      Translation.find(translation1.id).language_id.should == english.id
      Translation.find(translation1.id).form.should == "blag"
      Translation.find(translation1.id).pronunciation.should == "wumpf"
      Translation.find(translation2.id).language_id.should == spanish.id
      Translation.find(translation2.id).form.should == "blagitos"
      Translation.find(translation2.id).pronunciation.should == "wumpfitos"
      Translation.last.language_id.should == chinese.id
      Translation.last.form.should == "ni hao"
      Translation.last.pronunciation.should == "hello"
      IdiomTranslation.count.should == 3
    end

    it 'should fail on any incomplete objects' do
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :update, :id => idiom.id, :translation =>
        {
          "0" => {
            :id => translation1.id,
            :language_id => english.id,
            :form => "blag",
            :pronunciation => "wumpf"
          },
          "1" => {
            :id => translation2.id,
            :language_id => spanish.id,
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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term4 = Translation.make(:language_id => english.id, :form => "Hobo")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      term6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      get :select, :idiom_id => idiom1.id, :translation_id => term3.id
      

      assigns[:translations][0].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][0].language_id.should == english.id
      assigns[:translations][0].form.should == "Hobo"

      assigns[:translations][1].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][1].language_id.should == spanish.id
      assigns[:translations][1].form.should == "Abanana"

      assigns[:translations][2].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][2].language_id.should == spanish.id
      assigns[:translations][2].form.should == "Allegra"
    end

    it 'should redirect to terms_path if the idiom does not exist' do
      idiom1 = Idiom.make

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)

      get :select, :idiom_id => 100, :translation_id => term3.id

      response.should be_redirect
      response.should redirect_to terms_path
    end

    it 'should redirect to terms_path if the translation does not exist' do
      idiom1 = Idiom.make

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")

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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")

      t1 = Translation.make(:language_id => english.id, :form => "Zebra")
      t2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      t3 = Translation.make(:language_id => chinese.id, :form => "ce")
      t4 = Translation.make(:language_id => english.id, :form => "Hobo")
      t5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      t6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => t3.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => t5.id)

      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => t2.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => t4.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => t6.id)

      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom1.id)

      get :select_for_set, :set_id => set.id


      assigns[:translations][0].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][0].language_id.should == english.id
      assigns[:translations][0].form.should == "Hobo"

      assigns[:translations][1].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][1].language_id.should == spanish.id
      assigns[:translations][1].form.should == "Abanana"

      assigns[:translations][2].idiom_translations.idiom_id.should == idiom2.id
      assigns[:translations][2].language_id.should == spanish.id
      assigns[:translations][2].form.should == "Allegra"
    end

    it 'should redirect to sets_path if the set does not exist' do
      get :select_for_set, :set_id => 100

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end
end

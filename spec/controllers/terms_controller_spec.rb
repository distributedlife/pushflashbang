require 'spec_helper'

describe TermsController do
  before(:each) do
    @user = User.make
    sign_in :user, @user
  end

  context '"GET" index' do
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

  context '"PUT" add_to_set' do
    it 'should link the term to the set' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :add_to_set, :set_id => set.id, :id => idiom.id

      SetTerms.count.should == 1
      SetTerms.first.set_id.should == set.id
      SetTerms.first.term_id.should == idiom.id
    end

    it 'should return to user home if the set does not exist' do
      idiom = Idiom.make

      put :add_to_set, :set_id => 1, :id => idiom.id

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should return to the set home if the term does not exist' do
      set = Sets.make

      put :add_to_set, :set_id => set.id, :id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should not add a term twice if it already exists' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :add_to_set, :set_id => set.id, :id => idiom.id
      put :add_to_set, :set_id => set.id, :id => idiom.id

      SetTerms.count.should == 1
      SetTerms.first.set_id.should == set.id
      SetTerms.first.term_id.should == idiom.id
    end
  end

  context '"PUT" remove_from_set' do
    it 'should remove the term from the set' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)

      put :remove_from_set, :set_id => set.id, :id => idiom.id

      SetTerms.count.should == 0
    end

    it 'should return to user home if the set does not exist' do
      idiom = Idiom.make

      put :remove_from_set, :set_id => 1, :id => idiom.id

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should return to the set home if the term does not exist' do
      set = Sets.make

      put :remove_from_set, :set_id => set.id, :id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should not error a term twice is not linked' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)

      put :remove_from_set, :set_id => set.id, :id => idiom.id
      put :remove_from_set, :set_id => set.id, :id => idiom.id

      SetTerms.count.should == 0
    end
  end

  context '"POST" next_chapter' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 2)
    end

    it 'should move the term into the next chapter' do
      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1

      post :next_chapter, :set_id => @set.id, :id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 2
    end

    it 'should make a new chapter if the next does not exist' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2

      post :next_chapter, :set_id => @set.id, :id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 3
    end

    it 'should redirect to sets index if set does not exist' do
      post :next_chapter, :set_id => @set.id + 1, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :next_chapter, :set_id => @set.id, :id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :next_chapter, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :next_chapter, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should renormalise the chapters if a chapter is left empty' do
      SetTerms.delete_all
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 2)

      post :next_chapter, :set_id => @set.id, :id => @idiom4.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom4.id).first.chapter.should be 2
    end
  end

  context '"POST" prev_chapter' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")

      @idiom1 = Idiom.make
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation1.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id)


      @idiom2 = Idiom.make
      translation21 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation22 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => translation21.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => translation22.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 2)
    end

    it 'should move the term into the next chapter' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2

      post :prev_chapter, :set_id => @set.id, :id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
    end

    it 'should make a new chapter if the current chapter is 1 does not exist' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2
      post :prev_chapter, :set_id => @set.id, :id => @idiom2.id
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1


      post :prev_chapter, :set_id => @set.id, :id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 2
    end

    it 'should redirect to sets index if set does not exist' do
      post :prev_chapter, :set_id => @set.id + 1, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :prev_chapter, :set_id => @set.id, :id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :prev_chapter, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :prev_chapter, :set_id => @set.id, :id => @idiom2.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should renormalise the chapters if a chapter is left empty' do
      SetTerms.delete_all
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1)

      post :prev_chapter, :set_id => @set.id, :id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2
    end
  end

  context '"POST" next_position' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1, :position => 1)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1, :position => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1, :position => 3)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 1, :position => 4)
    end

    it 'should move the term into the next position, swapping with whatever is there' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1

      post :next_position, :set_id => @set.id, :id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should not move beyond the last position' do
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4

      post :next_position, :set_id => @set.id, :id => @idiom4.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should redirect to sets index if set does not exist' do
      post :next_position, :set_id => @set.id + 1, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :next_position, :set_id => @set.id, :id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :next_position, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :next_position, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end
  end

  context '"POST" prev_position' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1, :position => 1)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1, :position => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1, :position => 3)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 1, :position => 4)
    end

    it 'should move the term into the next position, swapping with whatever is there' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2

      post :prev_position, :set_id => @set.id, :id => @idiom2.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should not move beyond the first position' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1

      post :prev_position, :set_id => @set.id, :id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should redirect to sets index if set does not exist' do
      post :prev_position, :set_id => @set.id + 1, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :prev_position, :set_id => @set.id, :id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :prev_position, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :prev_position, :set_id => @set.id, :id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end
  end
end

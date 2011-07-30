require 'spec_helper'

describe LanguagesController do
  before(:each) do
    @user = User.make
    sign_in :user, @user
  end

  context '"GET" index' do
    it 'should return all languages' do
      Language.make
      Language.make

      get :index

      assigns[:languages].count.should == 2
    end
  end

  context '"GET" user_languages' do
    it 'should return all languages' do
      Language.make
      Language.make

      get :user

      assigns[:languages].count.should == 2
    end

    it 'should return all language the user knows' do
      l1 = Language.make
      Language.make
      UserLanguages.make(:user_id => @user.id, :language_id => l1.id)
      UserLanguages.make(:user_id => 100, :language_id => l1.id)

      get :user

      assigns[:user_languages].count.should == 1
    end
  end

  context '"POST" learn' do
    before(:each) do
      @language = Language.make
    end

    it 'should add the language to the user languages' do
      post :learn, :id => @language.id

      UserLanguages.all.count.should == 1
      UserLanguages.first.user_id.should == @user.id
      UserLanguages.first.language_id.should == @language.id
    end

    it 'should not add a language twice' do
      UserLanguages.make(:user_id => @user.id, :language_id => @language.id)
      UserLanguages.all.count.should == 1

      post :learn, :id => @language.id

      UserLanguages.all.count.should == 1
    end

    it 'should redirect to languages path' do
      post :learn, :id => @language.id

      response.should be_redirect
    end

    it 'should not add languages that do not exist' do
      post :learn, :id => 100

      UserLanguages.all.count.should == 0
    end
  end

  context '"POST" unlearn' do
    before(:each) do
      @language = Language.make
      @user_language = UserLanguages.make(:language_id => @language.id, :user_id => @user.id)
    end

    it 'should remove the language from the user languages' do
      UserLanguages.all.count.should == 1

      post :unlearn, :id => @language.id

      UserLanguages.all.count.should == 0
    end

    it 'should not remove a language that is not there' do
      UserLanguages.delete_all

      post :unlearn, :id => @language.id

      UserLanguages.all.count.should == 0
    end

    it 'should redirect to languages path' do
      post :unlearn, :id => @language.id

      response.should be_redirect
    end

    it 'should not remove languages that do not exist' do
      UserLanguages.all.count.should == 1
      
      post :unlearn, :id => 100

      UserLanguages.all.count.should == 1
    end
  end

  context '"GET" show' do
    it 'should return all sets associated with the language' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)
      language = Language.make(:name => "English")

      get :show, :id => language.id

      assigns[:language].should == language
      assigns[:sets].count.should == 1
    end

    it 'should break the returned sets into those associated with the user and those that are not' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      set2 = Sets.make
      set2_name = SetName.make(:sets_id => set2.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)
      set_term2 = SetTerms.make(:set_id => set2.id, :term_id => idiom.id)
      language = Language.make(:name => "English")

      UserSets.make(:user_id => @user.id, :set_id => set.id)

      get :show, :id => language.id

      assigns[:language].should == language
      assigns[:sets].count.should == 1
      assigns[:user_sets].count.should == 1
      assigns[:sets].first.id.should == set2.id
      assigns[:user_sets].first.id.should == set.id
    end

    it 'should redirect to user home if the language does not exist' do
      get :show, :id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end
  end
end

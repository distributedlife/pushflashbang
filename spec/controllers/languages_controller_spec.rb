require 'spec_helper'

describe LanguagesController do
  context '"GET" index' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return all languages' do
      Language.make
      Language.make

      get :index

      assigns[:languages].count.should == 2
    end

    it 'should return all language the user knows' do
      l1 = Language.make
      Language.make
      UserLanguages.make(:user_id => @user.id, :language_id => l1.id)
      UserLanguages.make(:user_id => 100, :language_id => l1.id)

      get :index

      assigns[:user_languages].count.should == 1
    end
  end

  context '"POST" learn' do
    before(:each) do
      @user = User.make
      sign_in :user, @user

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
end

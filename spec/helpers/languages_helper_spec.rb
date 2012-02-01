require 'spec_helper'

describe LanguagesHelper do
  before(:each) do
    @user = User.make!
    @language = Language.make!
  end

  describe 'language_is_valid?' do
    it 'should return true if language exists' do
      language_is_valid?(@language.id).should be true
    end

    it 'should reutrn false if language does not exist' do
      language_is_valid?(@language.id + 1).should be false
    end
  end

  describe 'language_is_valid_for_user?' do
    before(:each) do
      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
    end
    
    it 'should return false if user is learning language' do
      language_is_valid_for_user?(@language.id, @user.id).should be false
    end

    it 'should return false if the user is not learning the language' do
      language_is_valid_for_user?(@language.id, @user.id + 1).should be true
    end

    it 'should return false if the language does not exist' do
      language_is_valid_for_user?(@language.id + 1, @user.id).should be false
    end
  end

  describe 'user_is_learning_language?' do
    before(:each) do
      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
    end

    it 'should return true if user is learning language' do
      LanguagesHelper::user_is_learning_language?(@language.id, @user.id).should be true
    end

    it 'should return false if the user is not learning the language' do
      LanguagesHelper::user_is_learning_language?(@language.id, @user.id + 1).should be false
    end
  end
end

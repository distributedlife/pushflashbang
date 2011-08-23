require 'spec_helper'

describe User do
  context 'create new user' do
    it 'should allow account creation' do
      result = User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password", :native_language_id => 1).save!
      result.should == true

      user =  User.first
      user.email.should == "a@b.com"
    end

    it 'should not allow an account to exist if the email has been used' do
      User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password", :native_language_id => 1).save!

      lambda { User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password").save! }.should raise_error

      User.count.should == 1
    end

    it 'should not allow account creation if the passwords are not equal' do
      lambda { User.new(:email => "a@b.com", :password => "password", :password_confirmation => "passwords", :native_language_id => 1).save! }.should raise_error

      User.count.should == 0
    end

    it 'should require a language' do
      lambda { User.new(:email => "a@b.com", :password => "password", :password_confirmation => "passwords").save! }.should raise_error

      User.count.should == 0
    end
  end

  context 'migrate_all_users_without_language_to_english' do
    it 'should update all users without a native language' do

    end

    it 'should not update users that have a language' do
      lang = Language.make

      user = User.make(:native_language_id => lang.id)

      User::migrate_all_users_without_language_to_english

      user.native_language_id.should == lang.id
    end

    it 'should create the english language if it does not exist' do
      Language.count.should == 0

      User::migrate_all_users_without_language_to_english

      Language.count.should == 1
      Language.first.name.should == "English"
    end
  end
end
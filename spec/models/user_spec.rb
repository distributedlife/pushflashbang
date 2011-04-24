require 'spec_helper'

describe User do
  context 'create new user' do
    it 'should allow account creation' do
      result = User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password").save!
      result.should == true

      user =  User.first
      user.email.should == "a@b.com"
    end

    it 'should not allow an account to exist if the email has been used' do
      User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password").save!

      lambda { User.new(:email => "a@b.com", :password => "password", :password_confirmation => "password").save! }.should raise_error

      User.count.should == 1
    end

    it 'should not allow account creation if the passwords are not equal' do
      lambda { User.new(:email => "a@b.com", :password => "password", :password_confirmation => "passwords").save! }.should raise_error

      User.count.should == 0
    end
  end
end

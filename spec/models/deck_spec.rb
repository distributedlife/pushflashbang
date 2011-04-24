require 'spec_helper'

describe Deck do
  context 'to be valid' do
    before(:each) do
      @user = User.create(:email => 'a@b.com', :password => 'password', :confirm_password => 'password')
    end

    it 'should be associated with a user' do
      deck = Deck.new(:name => 'name', :desc => 'something', :lang => 'en', :country => 'au')

      deck.valid?.should == false
      deck.user = @user
      deck.valid?.should == true
    end

    it 'should require a name' do
      deck = Deck.new(:desc => 'something', :lang => 'en', :country => 'au')
      deck.user = @user

      deck.valid?.should == false
      deck.name = 'something'
      deck.valid?.should == true
    end

    it 'should require a language code' do
      deck = Deck.new(:name => 'name', :desc => 'something', :country => 'au')
      deck.user = @user

      deck.valid?.should == false
      deck.lang = 'es'
      deck.valid?.should == true
    end

    it 'should require a country code' do
      deck = Deck.new(:name => 'name', :desc => 'something', :lang => 'en')
      deck.user = @user

      deck.valid?.should == false
      deck.country = 'gb'
      deck.valid?.should == true
    end

    it 'should require names to be unique' do
      deck1 = Deck.new(:name => 'name', :desc => 'something', :lang => 'en', :country => 'au')
      deck1.user = @user
      deck1.valid?.should == true
      deck1.save!

      deck2 = Deck.new(:name => 'name', :desc => 'something', :lang => 'en', :country => 'au')
      deck2.user = @user
      deck2.valid?.should == false
      deck2.name = 'something else'
      deck2.valid?.should == true
    end
  end
end

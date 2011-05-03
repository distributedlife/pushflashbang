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

    it 'should default shared to false' do
      deck = Deck.new(:name => 'name', :desc => 'something', :lang => 'en', :country => 'au')
      deck.user = @user

      deck.valid?.should == true
      deck.shared = false
    end
  end
end

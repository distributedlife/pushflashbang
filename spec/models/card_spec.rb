require 'spec_helper'

describe Card do
  context 'to be valid' do
    before(:each) do
      @user = User.create(:email => 'a@b.com', :password => 'password', :confirm_password => 'password')
      @deck = Deck.new(:name => "my deck", :lang => 'en', :country => 'us')
      @deck.user = @user
      @deck.save!
    end

    it 'should be associated with a deck' do
      card = Card.new(:front => 'front', :back => 'back')

      card.valid?.should == false
      card.deck = @deck
      card.valid?.should == true
    end

    it 'should require a front' do
      card = Card.new(:back => 'back')
      card.deck = @deck

      card.valid?.should == false
      card.front = "front"
      card.valid?.should == true
    end
  end
end

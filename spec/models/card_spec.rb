require 'spec_helper'

describe Card do
  context 'to be valid' do
    before(:each) do
      @user = User.make
      @deck = Deck.make(:user_id => @user.id)
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

require 'spec_helper'

describe Card do
  context 'to be valid' do
    before(:each) do
      @user = User.make
      @deck = Deck.make(:user_id => @user.id)
    end

    it 'should be associated with a deck' do
      card = Card.new(:front => 'front', :back => 'back', :chapter => 1)

      card.valid?.should == false
      card.deck = @deck
      card.valid?.should == true
    end

    it 'should require a front' do
      card = Card.new(:back => 'back', :chapter => 1)
      card.deck = @deck

      card.valid?.should == false
      card.front = "front"
      card.valid?.should == true
    end

    it 'should require a chapter' do
      card = Card.new(:front => "fdgdfg", :back => 'back')
      card.deck = @deck

      card.valid?.should == false
      card.chapter = 1
      card.valid?.should == true
    end

    it 'should have a chapter greater than 0' do
      card = Card.new(:front => "fdgdfg", :back => 'back', :chapter => 0)
      card.deck = @deck

      card.valid?.should == false
      card.chapter = 1
      card.valid?.should == true

      card.chapter = 'a'
      card.valid?.should == false
    end
  end
end

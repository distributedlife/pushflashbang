require 'spec_helper'

describe Deck do
  context 'to be valid' do
    before(:each) do
      @user = User.create(:email => 'a@b.com', :password => 'password', :confirm_password => 'password')
    end

    it 'should be associated with a user' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])

      deck.valid?.should == false
      deck.user = @user
      deck.valid?.should == true
    end

    it 'should require a name' do
      deck = Deck.new(:description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == false
      deck.name = 'something'
      deck.valid?.should == true
    end

    it 'should default shared to false' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == true
      deck.shared = false
    end

    it 'should default support written answer to false' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == true
      deck.supports_written_answer = false
    end

    it 'should require a pronunciation side' do
      deck = Deck.new(:name => 'something')
      deck.user = @user

      deck.valid?.should == false
      deck.pronunciation_side = 'front'
      deck.valid?.should == true
    end

    it 'should be invalid if pronunciation_side is not in allowed list' do
      deck = Deck.new(:name => 'something')
      deck.user = @user

      deck.valid?.should be false

      Deck::SIDES.each do |side|
        deck.pronunciation_side = side
        deck.valid?.should == true
        deck.errors.empty?.should == true
      end

      deck.pronunciation_side = 'banana'
      deck.valid?.should == false
    end
  end
end

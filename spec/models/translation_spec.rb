require 'spec_helper'

describe Translation do
  before(:each) do
    @idiom = Idiom.make
  end

  context 'to be valid' do
    it 'must be associated with an idiom' do
      translation = Translation.new(:form => "hello", :language => "English")

      translation.valid?.should == false
      translation.idiom_id = @idiom
      translation.valid?.should == true
    end

    it 'should require a form' do
      translation = Translation.new(:language => "English")
      translation.idiom_id = @idiom

      translation.valid?.should == false
      translation.form = "hello"
      translation.valid?.should == true
    end

    it 'should require a language' do
      translation = Translation.new(:form => "hello")
      translation.idiom_id = @idiom

      translation.valid?.should == false
      translation.language = "english"
      translation.valid?.should == true
    end
  end
end

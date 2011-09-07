require 'spec_helper'

describe Language do
  context 'to be valid a language' do
    it 'should require a name' do
      language = Language.new
      language.valid?.should be false

      language.name = "English"
      language.valid?.should be true
    end
  end

  context 'get_or_create' do
    it 'should return the language if it exists' do
      language = Language.create(:name => "English")

      Language::get_or_create("English").should == language
    end
    it 'should create a language if it does not exist' do
      Language.count.should == 0

      Language::get_or_create("English")

      Language.count.should == 1
      Language.first.name.should == "English"
    end
  end
end

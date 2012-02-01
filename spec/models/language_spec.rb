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

  context 'enabled?' do
    it 'should return true if language is enabled' do
      l1 = Language.make!(:enabled => true)
      l2 = Language.make!(:enabled => false)

      l1.enabled?.should == true
      l2.enabled?.should == false
    end
  end

  context 'scope:only_enabled' do
    it 'should return only enabled languages' do
      l1 = Language.make!(:enabled => true)
      l2 = Language.make!(:enabled => false)

      r = Language.only_enabled
      r.count.should == 1
      r.include?(l1).should == true
      r.include?(l2).should == false
    end
  end

  context 'override:all' do
    it 'should not return disabled languages' do
      l1 = Language.make!(:enabled => true)
      l2 = Language.make!(:enabled => false)

      r = Language.all
      r.count.should == 1
      r.include?(l1).should == true
      r.include?(l2).should == false
    end
  end
end

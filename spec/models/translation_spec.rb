require 'spec_helper'

describe Translation do
  context 'to be valid' do
    it 'should require a form' do
      translation = Translation.new(:language_id => 1, :idiom_id => 1)

      translation.valid?.should == false
      translation.form = "hello"
      translation.valid?.should == true
    end

    it 'should require a language' do
      translation = Translation.new(:form => "hello", :idiom_id => 1)

      translation.valid?.should == false
      translation.language_id = 1
      translation.valid?.should == true
    end

    it 'should require a language' do
      translation = Translation.new(:language_id => 1, :form => "hello")

      translation.valid?.should == false
      translation.idiom_id = 1
      translation.valid?.should == true
    end

    it 'should allow an audio file to be attached' do
      translation = Translation.new(:form => "hello", :language_id => 1, :idiom_id => 1)

      translation.audio_file_name = File.join(Rails.root, 'features', 'support', 'paperclip', 'audio.mp3')
      translation.save!
      translation.valid?.should == true
    end
  end

  context 'delete' do
    it 'should be tested'
  end

  context 'all_sorted_by_idiom_language_and_form' do
    it 'should be tested'
  end

  context 'all_sorted_by_idiom_language_and_form_with_like_filter' do
    it 'should support a single filter'
    it 'should do partial matches'
    it 'should support multiple filters'
    it 'should be case insensitive'
    it 'should search by pronunciation'
  end
end

require 'spec_helper'

describe Translation do
  context 'to be valid' do
    it 'should require a form' do
      translation = Translation.new(:language_id => 1)

      translation.valid?.should == false
      translation.form = "hello"
      translation.valid?.should == true
    end

    it 'should require a language' do
      translation = Translation.new(:form => "hello")

      translation.valid?.should == false
      translation.language_id = 1
      translation.valid?.should == true
    end

    it 'should allow an audio file to be attached' do
      translation = Translation.new(:form => "hello", :language_id => 1)

      translation.audio_file_name = File.join(Rails.root, 'features', 'support', 'paperclip', 'audio.mp3')
      translation.save!
      translation.valid?.should == true
    end
  end

  context 'delete' do
    it 'should be tested'
  end

  context 'search' do
    it 'should pull out word matches in supported languages'
    it 'should pull out word types in support matches'
    it 'should do a partial match'
    it 'should filter by queried languages'
    it 'should filter by word types'
    it 'should return the used query'
    it 'sohuld return the language matches'
    it 'should return the word type matches'
  end
end

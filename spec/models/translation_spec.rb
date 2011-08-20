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
end

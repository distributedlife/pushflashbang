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
end

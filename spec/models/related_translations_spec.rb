require 'spec_helper'

describe RelatedTranslations do
  describe 'to be valid' do
    it 'requires all both translation properties' do
      rt = RelatedTranslations.new(:translation1_id => 1, :translation2_id => 2, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be true

      rt = RelatedTranslations.new(:translation2_id => 2, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be false

      rt = RelatedTranslations.new(:translation1_id => 1, :share_written_form => false, :share_audible_form => false, :share_mearning => false)
      rt.valid?.should be false
    end
  end
end

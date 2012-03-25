# -*- encoding : utf-8 -*-
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
    it 'should delete the translation' do
      a = Translation.make!

      Translation.count.should == 1

      a.delete

      Translation.count.should == 0
    end

    it 'should delete related translations for the translation' do
      a = Translation.make!
      b = Translation.make!
      c = Translation.make!
      RelatedTranslations.make!(:translation1_id => a.id, :translation2_id => b.id)
      RelatedTranslations.make!(:translation1_id => b.id, :translation2_id => a.id)
      RelatedTranslations.make!(:translation1_id => b.id, :translation2_id => c.id)

      Translation.count.should == 3

      a.delete

      Translation.count.should == 2
      RelatedTranslations.count.should == 1
    end
  end

  context 'all_sorted_by_idiom_language_and_form_with_like_filter' do
    context 'ignore pagination' do
      before(:each) do
        idiom1 = Idiom.make!
        idiom2 = Idiom.make!
        language = Language.make!
        @a = Translation.make!(:form => "elephant", :idiom_id => idiom1.id, :language_id => language.id)
        @b = Translation.make!(:form => "desire", :idiom_id => idiom2.id, :language_id => language.id, :pronunciation => "calm")
      end

      it 'should support a single filter' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "elephant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should do partial matches' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "ant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should support multiple filters' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter ["elephant", "desire"]

        results.count.should == 2
        results.first.should == @a
        results.last.should == @b
      end

      it 'should be case insensitive' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "ELEPHANT"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should search by pronunciation' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "CALM"

        results.count.should == 1
        results.first.should == @b
      end

      it 'should not return translations in a disabled language' do
        Language.all.each {|l| l.disable!}

        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "e"

        results.count.should == 0
      end

      it 'should return quoted words as exact matches' do
        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter ['"elephant"', "desire"]

        results.count.should == 1
        results.first.should == @a


        results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter '"elephant"'

        results.count.should == 1
        results.first.should == @a
      end
    end

    it 'should paginate correctly (idioms are paginated upon, translations are returned)' do
      idiom1 = Idiom.make!
      idiom2 = Idiom.make!
      idiom3 = Idiom.make!
      idiom4 = Idiom.make!
      language = Language.make!
      a = Translation.make!(:form => "aaa", :idiom_id => idiom1.id, :language_id => language.id)
      b = Translation.make!(:form => "fff", :idiom_id => idiom1.id, :language_id => language.id)
      c = Translation.make!(:form => "abc", :idiom_id => idiom2.id, :language_id => language.id)
      d = Translation.make!(:form => "aef", :idiom_id => idiom3.id, :language_id => language.id)
      e = Translation.make!(:form => "agh", :idiom_id => idiom3.id, :language_id => language.id)
      f = Translation.make!(:form => "aky", :idiom_id => idiom3.id, :language_id => language.id)
      g = Translation.make!(:form => "azz", :idiom_id => idiom4.id, :language_id => language.id)

      results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "a", 1, 1

      results.count.should == 2
      results.first.should == a
      results.last.should == b

      results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "a", 2, 1

      results.count.should == 1
      results.first.should == c


      results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "a", 1, 2
      results.count.should == 3
      results[0].should == a
      results[1].should == b
      results[2].should == c
      

      results = Translation::all_sorted_by_idiom_language_and_form_with_like_filter "a", 2, 2

      results.count.should == 4
      results[0].should == d
      results[1].should == e
      results[2].should == f
      results[3].should == g
    end
  end

  context 'all_in_set_sorted_by_idiom_language_and_form_with_like_filter' do
    context 'ignore pagination' do

      before(:each) do
        idiom1 = Idiom.make!
        idiom2 = Idiom.make!
        idiom3 = Idiom.make!
        language = Language.make!
        @a = Translation.make!(:form => "elephant", :idiom_id => idiom1.id, :language_id => language.id)
        @b = Translation.make!(:form => "desire", :idiom_id => idiom2.id, :language_id => language.id, :pronunciation => "calm")
        @c = Translation.make!(:form => "elephants", :idiom_id => idiom3.id, :language_id => language.id)

        @set1 = Sets.make!
        SetTerms.create(:set_id => @set1.id, :term_id => idiom3.id, :chapter => 1, :position => 1)
      end

      it 'should support a single filter' do
        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, "elephant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should do partial matches' do
        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, "ant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should support multiple filters' do
        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, ["elephant", "desire"]

        results.count.should == 2
        results.first.should == @a
        results.last.should == @b
      end

      it 'should be case insensitive' do
        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, "ELEPHANT"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should search by pronunciation' do
        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, "CALM"

        results.count.should == 1
        results.first.should == @b
      end

      it 'should not return translations in a disabled language' do
        Language.all.each {|l| l.disable!}

        results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter @set1.id, "CALM"

        results.count.should == 0
      end
    end

    it 'should paginate correctly' do
      idiom1 = Idiom.make!
      idiom2 = Idiom.make!
      idiom3 = Idiom.make!
      idiom4 = Idiom.make!
      idiom5 = Idiom.make!
      language = Language.make!
      a = Translation.make!(:form => "aaa", :idiom_id => idiom1.id, :language_id => language.id)
      b = Translation.make!(:form => "fff", :idiom_id => idiom1.id, :language_id => language.id)
      c = Translation.make!(:form => "abc", :idiom_id => idiom2.id, :language_id => language.id)
      d = Translation.make!(:form => "aef", :idiom_id => idiom3.id, :language_id => language.id)
      e = Translation.make!(:form => "agh", :idiom_id => idiom3.id, :language_id => language.id)
      f = Translation.make!(:form => "aky", :idiom_id => idiom3.id, :language_id => language.id)
      g = Translation.make!(:form => "azz", :idiom_id => idiom4.id, :language_id => language.id)
      Translation.make!(:form => "aaa", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "fff", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "abc", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "aef", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "agh", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "aky", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "azz", :idiom_id => idiom5.id, :language_id => language.id)

      set2 = Sets.make!
      SetTerms.create(:term_id => idiom5.id, :set_id => set2.id, :chapter => 1, :position => 1)


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 1, 1

      results.count.should == 2
      results.first.should == a
      results.last.should == b

      
      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 2, 1

      results.count.should == 1
      results.first.should == c


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 1, 2
      results.count.should == 3
      results[0].should == a
      results[1].should == b
      results[2].should == c


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 2, 2

      results.count.should == 4
      results[0].should == d
      results[1].should == e
      results[2].should == f
      results[3].should == g
    end
  end

  context 'all_in_any_set_sorted_by_idiom_language_and_form_with_like_filter' do
    context 'ignore pagination' do

      before(:each) do
        @idiom1 = Idiom.make!
        @idiom2 = Idiom.make!
        @idiom3 = Idiom.make!
        language = Language.make!
        @a = Translation.make!(:form => "elephant", :idiom_id => @idiom1.id, :language_id => language.id)
        @b = Translation.make!(:form => "desire", :idiom_id => @idiom2.id, :language_id => language.id, :pronunciation => "calm")
        @c = Translation.make!(:form => "elephants", :idiom_id => @idiom3.id, :language_id => language.id)

        @set1 = Sets.make!
        SetTerms.create(:set_id => @set1.id, :term_id => @idiom3.id, :chapter => 1, :position => 1)
      end

      it 'should support a single filter' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "elephant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should do partial matches' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "ant"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should support multiple filters' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter ["elephant", "desire"]

        results.count.should == 2
        results.first.should == @a
        results.last.should == @b
      end

      it 'should be case insensitive' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "ELEPHANT"

        results.count.should == 1
        results.first.should == @a
      end

      it 'should search by pronunciation' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "CALM"

        results.count.should == 1
        results.first.should == @b
      end

      it 'should not return translations in a disabled language' do
        Language.all.each {|l| l.disable!}

        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "CALM"

        results.count.should == 0
      end

      it 'should not return idioms that are in any set' do
        results = Translation::all_not_in_any_set_sorted_by_idiom_language_and_form_with_like_filter "CALM"

        SetTerms.create(:set_id => @set1.id, :term_id => @idiom2.id, :chapter => 1, :position => 1)

        results.count.should == 0
      end
    end

    it 'should paginate correctly' do
      idiom1 = Idiom.make!
      idiom2 = Idiom.make!
      idiom3 = Idiom.make!
      idiom4 = Idiom.make!
      idiom5 = Idiom.make!
      language = Language.make!
      a = Translation.make!(:form => "aaa", :idiom_id => idiom1.id, :language_id => language.id)
      b = Translation.make!(:form => "fff", :idiom_id => idiom1.id, :language_id => language.id)
      c = Translation.make!(:form => "abc", :idiom_id => idiom2.id, :language_id => language.id)
      d = Translation.make!(:form => "aef", :idiom_id => idiom3.id, :language_id => language.id)
      e = Translation.make!(:form => "agh", :idiom_id => idiom3.id, :language_id => language.id)
      f = Translation.make!(:form => "aky", :idiom_id => idiom3.id, :language_id => language.id)
      g = Translation.make!(:form => "azz", :idiom_id => idiom4.id, :language_id => language.id)
      Translation.make!(:form => "aaa", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "fff", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "abc", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "aef", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "agh", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "aky", :idiom_id => idiom5.id, :language_id => language.id)
      Translation.make!(:form => "azz", :idiom_id => idiom5.id, :language_id => language.id)

      set2 = Sets.make!
      SetTerms.create(:term_id => idiom5.id, :set_id => set2.id, :chapter => 1, :position => 1)


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 1, 1

      results.count.should == 2
      results.first.should == a
      results.last.should == b


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 2, 1

      results.count.should == 1
      results.first.should == c


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 1, 2
      results.count.should == 3
      results[0].should == a
      results[1].should == b
      results[2].should == c


      results = Translation::all_not_in_set_sorted_by_idiom_language_and_form_with_like_filter set2.id, "a", 2, 2

      results.count.should == 4
      results[0].should == d
      results[1].should == e
      results[2].should == f
      results[3].should == g
    end
  end

  context 'remove duplicates' do
    it 'should ignore those that share form but not language' do
      a = Translation.make!
      b = Translation.make!(:form => a.form, :language_id => a.language_id + 1)

      Translation.count.should == 2

      Translation::remove_duplicates

      Translation.count.should == 2
      a.should_not == b
    end

    it 'should ignore those that share language but not form' do
      a = Translation.make!
      b = Translation.make!(:language_id => a.language_id)

      Translation.count.should == 2

      Translation::remove_duplicates

      Translation.count.should == 2
      a.reload
      b.reload
      a.should_not == b
    end

    it 'should ignore those that share language and form but not idiom' do
      a = Translation.make!
      b = Translation.make!(:form => a.form, :language_id => a.language_id, :idiom_id => a.idiom_id + 1)

      Translation.count.should == 2

      Translation::remove_duplicates

      Translation.count.should == 2
      a.reload
      b.reload
      a.should_not == b
    end

    it 'should merge all duplicates' do
      a = Translation.make!
      b = a.dup
      b.save!
      c = a.dup
      c.save!

      Translation.count.should == 3

      Translation::remove_duplicates

      Translation.count.should == 1
    end

    it 'should delete related translations' do
      a = Translation.make!
      b = a.dup
      b.save!
      c = Translation.make!
      RelatedTranslations.make!(:translation1_id => a.id, :translation2_id => b.id)
      RelatedTranslations.make!(:translation1_id => b.id, :translation2_id => a.id)
      RelatedTranslations.make!(:translation1_id => a.id, :translation2_id => c.id)

      Translation.count.should == 3

      Translation::remove_duplicates

      Translation.count.should == 2
      RelatedTranslations.count.should == 1
    end
  end
end

require 'spec_helper'

describe UserIdiomSchedule do
  context 'create' do
    it 'should require a user_id' do
      card_schedule = UserIdiomSchedule.new(:idiom_id => 1, :language_id => 1)
      card_schedule.valid?.should == false
      card_schedule.user_id = 2
      card_schedule.valid?.should == true
    end

    it 'should require an idiom_id' do
      card_schedule = UserIdiomSchedule.new(:user_id => 1, :language_id => 1)
      card_schedule.valid?.should == false
      card_schedule.idiom_id = 2
      card_schedule.valid?.should == true
    end

    it 'should require an language_id' do
      card_schedule = UserIdiomSchedule.new(:user_id => 1, :idiom_id => 1)
      card_schedule.valid?.should == false
      card_schedule.language_id = 2
      card_schedule.valid?.should == true
    end
  end

  context 'get_next_due_for_user' do
    before(:each) do
      @user = User.make

      @idiom = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom.id, :translation_id => @t1.id)

      @set = Sets.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      next_schedule = UserIdiomSchedule.get_next_due_for_user(@language.id, @user.id)
      next_schedule.nil?.should == true
    end

    it 'should return nil if there is no due items' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)

      next_schedule = UserIdiomSchedule.get_next_due_for_user(@language.id, @user.id)
      next_schedule.nil?.should == true
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language2.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      next_schedule = UserIdiomSchedule.get_next_due_for_user(@language.id, @user.id)
      next_schedule.nil?.should == true
    end

    it 'should return the most due item' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user(@language.id, @user.id)
      next_schedule.should == us1di1
    end
  end

  context 'get_next_due_for_user_for_set' do
    before(:each) do
      @user = User.make

      @idiom1 = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t1.id)

      @idiom2 = Idiom.make
      @t2 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t2.id)

      @set1 = Sets.make
      SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id)

      @set2 = Sets.make
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom2.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set(@language.id, @user.id, @set1.id)
      next_schedule.nil?.should == true
    end

    it 'should return nil if there is no due items in the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 5.days.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set(@language.id, @user.id, @set1.id)
      next_schedule.nil?.should == true
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language2.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set(@language.id, @user.id, @set1.id)
      next_schedule.nil?.should == true
    end

    it 'should return the most due item for the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set(@language.id, @user.id, @set2.id)
      next_schedule.should == us2di5
    end
  end

  context 'get_due_count_for_user' do
    before(:each) do
      @user = User.make

      @idiom = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom.id, :translation_id => @t1.id)

      @set = Sets.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      count = UserIdiomSchedule.get_due_count_for_user(@language.id, @user.id)
      count.should == 0
    end

    it 'should return nil if there is no due items' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)

      count = UserIdiomSchedule.get_due_count_for_user(@language.id, @user.id)
      count.should == 0
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language2.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      count = UserIdiomSchedule.get_due_count_for_user(@language.id, @user.id)
      count.should == 0
    end

    it 'should return the most due item' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user(@language.id, @user.id)
      count.should == 10
    end
  end

  context 'get_due_count_for_user_for_set' do
    before(:each) do
      @user = User.make

      @idiom1 = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t1.id)

      @idiom2 = Idiom.make
      @t2 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t2.id)

      @set1 = Sets.make
      SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id)

      @set2 = Sets.make
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom2.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      count = UserIdiomSchedule.get_due_count_for_user_for_set(@language.id, @user.id, @set1.id)
      count.should == 0
    end

    it 'should return nil if there is no due items' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      count = UserIdiomSchedule.get_due_count_for_user_for_set(@language.id, @user.id, @set1.id)
      count.should == 0
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 1.day.from_now)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language2.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.day.ago)

      count = UserIdiomSchedule.get_due_count_for_user_for_set(@language.id, @user.id, @set1.id)
      count.should == 0
    end

    it 'should return the most due item' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_set(@language.id, @user.id, @set2.id)
      count.should == 5
    end
  end

  context 'get_next_due_for_user_for_proficiencies' do
    before(:each) do
      @user = User.make

      @idiom1 = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t1.id)

      @idiom2 = Idiom.make
      @t2 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t2.id)

      @set1 = Sets.make
      SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id)

      @set2 = Sets.make
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom2.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [1])
      next_scheduled.nil?.should be true
    end

    it 'should return nil if there is no due items in the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)

      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [2])
      next_scheduled.nil?.should be true
      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [16])
      next_scheduled.nil?.should be true
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language2.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 10.day.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 9.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 8.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 7.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 6.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [1,2,4,8,16])
      next_schedule.nil?.should == true
    end

    it 'should return the most due item for the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [2])
      next_scheduled.should == us1di2

      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [2, 16])
      next_scheduled.should == us1di2

      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [16])
      next_scheduled.should == us1di5

      next_scheduled = UserIdiomSchedule.get_next_due_for_user_for_proficiencies(@language.id, @user.id, [1, 2, 4, 8, 16])
      next_scheduled.should == us1di1
    end
  end

  context 'get_next_due_for_user_for_set_for_proficiencies' do
    before(:each) do
      @user = User.make

      @idiom1 = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t1.id)

      @idiom2 = Idiom.make
      @t2 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t2.id)

      @set1 = Sets.make
      SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id)

      @set2 = Sets.make
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom2.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1])
      next_schedule.nil?.should == true
    end

    it 'should return nil if there is no due items in the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [2])
      next_schedule.nil?.should == true
      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1,2,4,8,16])
      next_schedule.nil?.should == true
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language2.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 10.day.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 9.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 8.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 7.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 6.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1,2,4,8,16])
      next_schedule.nil?.should == true
    end

    it 'should return the most due item for the set' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2])
      next_schedule.should == us2di2
      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2,8])
      next_schedule.should == us2di4
      next_schedule = UserIdiomSchedule.get_next_due_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2,8,1])
      next_schedule.should == us2di4
    end
  end

  context 'get_due_count_for_user_for_proficiencies' do
    before(:each) do
      @user = User.make

      @idiom = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom.id, :translation_id => @t1.id)

      @set = Sets.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [1])
      count.should == 0
    end

    it 'should return nil if there is no due items' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [1])
      count.should == 0
      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [2])
      count.should == 0
      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [16])
      count.should == 0
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language2.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 10.day.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 9.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 8.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 7.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 6.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [1,2,4,8,16])
      count.should == 0
    end

    it 'should return the most due item' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [2])
      count.should == 2

      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [2, 4])
      count.should == 4

      count = UserIdiomSchedule.get_due_count_for_user_for_proficiencies(@language.id, @user.id, [2, 4, 16])
      count.should == 6
    end
  end

  context 'get_due_count_for_user_for_set_for_proficiencies' do
    before(:each) do
      @user = User.make

      @idiom1 = Idiom.make
      @t1 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t1.id)

      @idiom2 = Idiom.make
      @t2 = Translation.make
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t2.id)

      @set1 = Sets.make
      SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id)

      @set2 = Sets.make
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom2.id)

      @language = Language.make
      @language2 = Language.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should return nil if there are no scheduled items at all' do
      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1])
      count.should == 0
    end

    it 'should return nil if there is no due items' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [2])
      count.should == 0
      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1,2,4,8,16])
      count.should == 0
    end

    it 'should return only due items for the language' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.from_now, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.from_now, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.from_now, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.from_now, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.from_now, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language2.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 10.day.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 9.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 8.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 7.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 6.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set1.id, [1,2,4,8,16])
      count.should == 0
    end

    it 'should return the most due item' do
      us1 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @language.id)
      us1di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 10.day.ago, :review_type => 1)
      us1di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 9.days.ago, :review_type => 2)
      us1di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 8.days.ago, :review_type => 4)
      us1di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 7.days.ago, :review_type => 8)
      us1di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us1.id, :due => 6.days.ago, :review_type => 16)
      us2 = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom2.id, :language_id => @language.id)
      us2di1 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 5.days.ago, :review_type => 1)
      us2di2 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 4.days.ago, :review_type => 2)
      us2di3 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 3.days.ago, :review_type => 4)
      us2di4 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 2.days.ago, :review_type => 8)
      us2di5 = UserIdiomDueItems.make(:user_idiom_schedule_id => us2.id, :due => 1.days.ago, :review_type => 16)

      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2])
      count.should == 1
      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2,4])
      count.should == 2
      count = UserIdiomSchedule.get_due_count_for_user_for_set_for_proficiencies(@language.id, @user.id, @set2.id, [2,4,16])
      count.should == 3
    end
  end

  context 'get_first_unscheduled_term_for_user_for_set_for_proficiencies' do
    before(:each) do
      @english = Language.make
      @spanish = Language.make
      @chinese = Language.make

      @user = User.make(:native_language_id => @english.id)

      #an idiom with spanish, english and chinese
      @idiom1 = Idiom.make
      @t11 = Translation.make(:language_id => @english.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t11.id)
      @t12 = Translation.make(:language_id => @spanish.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t12.id)
      @t13 = Translation.make(:language_id => @chinese.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => @t12.id)

      #english and chinese
      @idiom2 = Idiom.make
      @t21 = Translation.make(:language_id => @english.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t21.id)
      @t22 = Translation.make(:language_id => @chinese.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => @t22.id)

      #spanish and chinese
      @idiom3 = Idiom.make
      @t31 = Translation.make(:language_id => @spanish.id)
      IdiomTranslation.make(:idiom_id => @idiom3.id, :translation_id => @t31.id)
      @t32 = Translation.make(:language_id => @chinese.id)
      IdiomTranslation.make(:idiom_id => @idiom3.id, :translation_id => @t32.id)

      #an idiom with spanish, english
      @idiom4 = Idiom.make
      @t41 = Translation.make(:language_id => @english.id)
      IdiomTranslation.make(:idiom_id => @idiom4.id, :translation_id => @t41.id)
      @t42 = Translation.make(:language_id => @spanish.id)
      IdiomTranslation.make(:idiom_id => @idiom4.id, :translation_id => @t42.id)

      #an idiom with spanish, english
      @idiom5 = Idiom.make
      @t51 = Translation.make(:language_id => @english.id)
      IdiomTranslation.make(:idiom_id => @idiom5.id, :translation_id => @t51.id)
      @t52 = Translation.make(:language_id => @spanish.id)
      IdiomTranslation.make(:idiom_id => @idiom5.id, :translation_id => @t52.id)


      @set1 = Sets.make
      @st11 = SetTerms.make(:set_id => @set1.id, :term_id => @idiom1.id, :chapter => 1, :position => 1)
      @st12 = SetTerms.make(:set_id => @set1.id, :term_id => @idiom2.id, :chapter => 1, :position => 2) #to be ignore
      @st13 = SetTerms.make(:set_id => @set1.id, :term_id => @idiom3.id, :chapter => 1, :position => 3) #to be ignore
      @st14 = SetTerms.make(:set_id => @set1.id, :term_id => @idiom4.id, :chapter => 1, :position => 4)
      @st15 = SetTerms.make(:set_id => @set1.id, :term_id => @idiom5.id, :chapter => 2, :position => 1)

      @set2 = Sets.make

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should ignore terms that have been reviewed for the specified review type' do
      schedule = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @spanish.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 2, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 4, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 8, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 16, :due => 1.day.from_now)

      first = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies @spanish.id, @english.id, @user.id, @set1.id, [32]

      first.should == @st11
    end

    it 'should ignore terms that dont support the users native language' do
      schedule = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @spanish.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 2, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 4, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 8, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 16, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 32, :due => 1.day.from_now)

      first = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies @spanish.id, @english.id, @user.id, @set1.id, [1,2,4,8,16,32]

      first.should == @st14
    end

    it 'should ignore terms that dont support the learn language' do
      schedule = UserIdiomSchedule.make(:user_id => @user.id, :idiom_id => @idiom1.id, :language_id => @spanish.id)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 2, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 4, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 8, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 16, :due => 1.day.from_now)
      UserIdiomDueItems.make(:user_idiom_schedule_id => schedule.id, :review_type => 32, :due => 1.day.from_now)

      first = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies @spanish.id, @english.id, @user.id, @set1.id, [1,2,4,8,16,32]

      first.should == @st14
    end

    it 'should ignore terms that are not in the set' do
      first = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies @spanish.id, @english.id, @user.id, @set2.id, [1,2,4,8,16,32]

      first.nil?.should be true
    end

    it 'should return the next unscheduled for the set, user native lang, learned language sorted by position and chapter' do
      first = UserIdiomSchedule::get_first_unscheduled_term_for_user_for_set_for_proficiencies @spanish.id, @english.id, @user.id, @set1.id, [1,2,4,8,16,32]

      first.should == @st11
    end

    it 'should return terms that do not have audio when the review mode is not HEARING'
    it 'should not return terms that do not have audio when the review mode is HEARING'
    it 'should not terms that have audio when the review mode is HEARING'
  end
end

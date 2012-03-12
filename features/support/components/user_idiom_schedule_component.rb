# -*- encoding : utf-8 -*-
module UserIdiomScheduleComponent
  def create_schedule_and_due_items user_id, idiom_id, language_id, due_date
    schedule = UserIdiomSchedule.create(:user_id => user_id, :idiom_id => idiom_id, :language_id => language_id)

    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 1, :interval => CardTiming.first.seconds)
    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 2, :interval => CardTiming.first.seconds)
    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 4, :interval => CardTiming.first.seconds)
    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 8, :interval => CardTiming.first.seconds)
    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 16, :interval => CardTiming.first.seconds)
    UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => due_date, :review_type => 32, :interval => CardTiming.first.seconds)
  end
end

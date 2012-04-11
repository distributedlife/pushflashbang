# -*- encoding : utf-8 -*-
include ArrayHelper

class Idiom < ActiveRecord::Base
  has_many :translations

  attr_accessible :idiom_type

  def supports_language? language_id
    self.translations.where(:language_id => language_id).count > 0
  end
  
  def self.translations_in_idiom_and_language idiom_id, language_id
    Translation.joins(:languages).order(:form).where(:language_id => language_id, :idiom_id => idiom_id)
  end


  def self.get_idiom_containing_form form
    translation = get_first Translation.where(:form => form)

    return nil if translation.nil?

    Idiom.find(translation.idiom_id)
  end


  def self.get_from_translations translation_ids
    translations = Translation.find(:all, :conditions => ['id in (?)', translation_ids])
    translations = translations.map {|t| t.idiom_id}
    Idiom.find(translations)
  end

  
  def merge_into idiom_id
    self.translations.each do |t|
      t.idiom_id = idiom_id
      t.save
    end

    SetTerms.where(:term_id => self.id).each do |st|
      unless SetTerms.where(:term_id => idiom_id, :set_id => st.set_id).empty?
        st.delete
      else
        st.term_id = idiom_id
        st.save
      end
    end

    UserIdiomSchedule.where(:idiom_id => self.id).each do |uis|
      merge_target_schedule = get_first UserIdiomSchedule.where(:idiom_id => idiom_id, :user_id => uis.user_id, :language_id => uis.language_id)

      unless merge_target_schedule.nil?
        merge_target_due_items = UserIdiomDueItems.where(:user_idiom_schedule_id => merge_target_schedule.id)
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis.id).each do |uidi|
          mt_uidi = merge_target_due_items.select {|mt_uidi| mt_uidi.review_type == uidi.review_type}
          if mt_uidi.empty?
            uidi.user_idiom_schedule_id = merge_target_schedule.id
            uidi.save

            next
          end

          
          now = Time.now

          mt_uidi_from_now = mt_uidi.first.due - now
          uidi_from_now = uidi.due - now


          if mt_uidi_from_now < uidi_from_now
            #the merge source is due next, so let's use that one
            uidi.user_idiom_schedule_id = merge_target_schedule.id
            uidi.save
            mt_uidi.first.delete
          else
            #the merge target is due next, so let's use that one
            uidi.delete
          end
        end

        uis.delete
      else
        uis.idiom_id = idiom_id
        uis.save
      end
    end

    UserIdiomReview.where(:idiom_id => self.id).each do |uir|
      uir.idiom_id = idiom_id
      uir.save
    end

    Translation::remove_duplicates

    self.delete
  end
end

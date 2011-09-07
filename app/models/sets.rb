class Sets < ActiveRecord::Base
  has_many :set_name
  has_many :set_terms, :class_name => "SetTerms", :foreign_key => "set_id"

  def delete
    SetName.where(:sets_id => self.id).each do |set_name|
      set_name.delete
    end

    return super
  end

  def migrate_from_deck deck_id
    deck = Deck.find deck_id
    next if deck.nil?

    chinese = Language::get_or_create "Chinese (Simplified)"
    english = Language::get_or_create "English"

    index = 1
    current_chapter = 1
    Card.order(:id).where(:deck_id => deck.id).each do |card|
      if current_chapter != card.chapter
        index = 1
        current_chapter = current_chapter + 1
      end

      idiom = Idiom.create

      chinese_translation = Translation.create(:idiom_id => idiom.id, :language_id => chinese.id, :form => card.front, :pronunciation => card.pronunciation)
      if card.audio.file?
        chinese_translation.audio = card.audio
        chinese_translation.save!
      end
      IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => chinese_translation.id)

      card.back.split(',').each do |form|
        form.strip!

        english_translation = Translation.create(:idiom_id => idiom.id, :language_id => english.id, :form => form, :pronunciation => "")
        IdiomTranslation.create(:idiom_id => idiom.id, :translation_id => english_translation.id)

        RelatedTranslations::create_relationships_for_translation english_translation
      end
      RelatedTranslations::create_relationships_for_translation chinese_translation


      SetTerms.create(:set_id => self.id, :term_id => idiom.id, :chapter => card.chapter, :position => index)
      index = index + 1

      migrate_reviews card.id, idiom.id, chinese.id
      migrate_schedules card.id, idiom.id, chinese.id
    end
  end

  def rebuild_all_relationships
    Translation.all.each do |t|
      puts "finding relationships for #{t.name}"
      RelatedTranslations::create_relationships_for_translation t
    end
  end

  private
  def migrate_reviews card_id, idiom_id, language_id
    map_result_success = Hash.new
    map_result_success['didnt_know'] = false
    map_result_success['partial_correct'] = false
    map_result_success['shaky_good'] = true
    map_result_success['good'] = true

    UserCardReview.where(:card_id => card_id).each do |review|
      user_idiom_review = UserIdiomReview.new
      user_idiom_review.user_id = review.user_id
      user_idiom_review.idiom_id = idiom_id
      user_idiom_review.language_id = language_id
      user_idiom_review.due = review.due
      user_idiom_review.review_start = review.review_start
      user_idiom_review.reveal = review.reveal
      user_idiom_review.success = map_result_success[review.result_success]
      user_idiom_review.interval = review.interval
      user_idiom_review.review_type = review.review_type
      user_idiom_review.result_recorded = review.result_recorded

      user_idiom_review.save!
    end
  end

  def migrate_schedules card_id, idiom_id, language_id
    UserCardSchedule.where(:card_id => card_id).each do |schedule|
      user_idiom_schedule = UserIdiomSchedule.new
      user_idiom_schedule.user_id = schedule.user_id
      user_idiom_schedule.idiom_id = idiom_id
      user_idiom_schedule.language_id = language_id
      user_idiom_schedule.save!

      review_types_done = []
      UserCardReview.where(:card_id => card_id, :user_id => schedule.user_id).each do |review|
        next if (review_types_done & [review.review_type] == [review.review_type])

        user_idiom_due_item = UserIdiomDueItems.new(:user_idiom_schedule_id => user_idiom_schedule.id)
        user_idiom_due_item.review_type = review.review_type
        user_idiom_due_item.due = schedule.due
        user_idiom_due_item.interval = schedule.interval
        user_idiom_due_item.save!

        review_types_done << review.review_type
      end
    end
  end
end

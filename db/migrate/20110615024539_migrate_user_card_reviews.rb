class MigrateUserCardReviews < ActiveRecord::Migration
  def self.up
    #create column to store migrate data
    add_column :user_card_reviews, :gen_from_migrate, :boolean, :default => false


    #migrate data
    UserCardReview.all.each do |user_card_review|
      next unless user_card_review.review_type.nil?

      #get deck for user card review
      begin
        card = Card.find user_card_review.card_id
        deck = Deck.find card.deck_id
      rescue
        next
      end

      #for each review type the deck supports; update the existing review and if
      # necessary create additional reviews with the same data except the review_type
      updated_first = false
      Deck::REVIEW_TYPES.each do |review_type|
        if deck.review_types & review_type == review_type
          unless updated_first
            user_card_review.review_type = review_type
            user_card_review.save
            updated_first = true
          else
            additional_review = user_card_review.clone
            additional_review.review_type = review_type
            additional_review.gen_from_migrate = true
            additional_review.save
          end
        end
      end
    end
  end

  def self.down
    UserCardReview.all.each do |user_card_review|
      if user_card_review.gen_from_migrate
        #delete records created by the migrate
        user_card_review.delete
      else
        #reset records changed by the migrate
        user_card_review.review_type = nil
        user_card_review.save
      end
    end

    #remove column that stores the migrate data
    remove_column :user_card_reviews, :gen_from_migrate
  end
end

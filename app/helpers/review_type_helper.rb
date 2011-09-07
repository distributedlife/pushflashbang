module ReviewTypeHelper
  def parse_review_types review_types
    return [] if review_types.nil?

    review_type_nums = []
    review_types.split(',').each do |review_type|
      review_type.strip!

      value = UserIdiomReview.to_review_type_int(review_type)
      review_type_nums << value unless value.nil?
    end

    return review_type_nums
  end
end
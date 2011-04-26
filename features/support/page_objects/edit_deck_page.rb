module EditDeckPage
  def is_get?
    true
  end

  def url id
    "/deck/#{id}/edit"
  end

  def is_current_page?
    @session.has_content?("Edit Deck")
  end

  def name= value
    @session.fill_in('deck_name', :with => value)
  end

  def description= value
    @session.fill_in('deck_description', :with => value)
  end

  def lang= value
    @session.fill_in('deck_lang', :with => value)
  end

  def country= value
    @session.fill_in('deck_country', :with => value)
  end
end

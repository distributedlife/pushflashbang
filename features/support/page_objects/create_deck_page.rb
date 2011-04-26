module CreateDeckPage
  def is_get?
    false
  end

  def navigate_to
    @session.visit "/users"
    @session.click_on "Create Deck"
  end

  def is_current_page?
    @session.has_content?("Create new deck")
  end

  def create_deck name, description, lang, country
    @session.fill_in('deck_name', :with => name)
    @session.fill_in('deck_description', :with => description)
    @session.fill_in('deck_lang', :with => lang)
    @session.fill_in('deck_country', :with => country)

    self.do_create
  end

  def do_create
    @session.click_on "Create Deck"
  end
end

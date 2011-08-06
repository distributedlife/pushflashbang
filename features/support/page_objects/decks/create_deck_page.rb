module CreateDeckPage
  def is_get?
    false
  end

  def navigate_to
    @session.visit "/users"
    @session.find_link("add_deck").click
  end

  def is_current_page?
    @session.has_content?("Create new deck").should == true
  end

  def create_deck name, description#, lang, country
    @session.fill_in('deck_name', :with => name)
    @session.fill_in('deck_description', :with => description)

    self.do_create
  end

  def do_create
    @session.click_on "Create Deck"
  end
end

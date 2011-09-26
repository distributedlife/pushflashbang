module SelectTermForSetPage
  def is_get?
    false
  end

  def url sut
    "/terms/select_for_set/?set_id#{sut.get(:set).id}"
  end

  def is_current_page?
    @session.has_content?("Select a term").should == true
  end

  def select_term idiom_id
    @session.find_link("term_#{idiom_id}_select").click
  end

  def search_for term
    @session.fill_in(:q, :with => term)
    @session.click_link_or_button("search_query")
  end
end

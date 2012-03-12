# -*- encoding : utf-8 -*-
module ShowTermsPage
  def is_get?
    true
  end

  def url sut
    "/terms/"
  end

  def is_current_page?
    @session.has_content?("All terms").should == true
  end

  def is_on_page translation_hash
    @session.has_content?(translation_hash[:form]).should == true
    @session.has_content?(translation_hash[:language]).should == true
    @session.has_content?(translation_hash[:pronunciation]).should == true unless translation_hash[:pronunciation].nil?
  end

  def add_to_set index
    @session.find_link("term_#{index}_add_to_set").click
  end

  def search_for term
    @session.fill_in(:q, :with => term)
    @session.click_link_or_button("search_query")
  end
end

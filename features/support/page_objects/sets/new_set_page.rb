# -*- encoding : utf-8 -*-
module NewSetPage
  def is_get?
    true
  end

  def url sut
    "/sets/new"
  end

  def is_current_page?
    @session.has_content?("Create a set of terms to learn").should == true
  end

  def fill_in hash
    @session.fill_in("set_name_name", :with => hash[:name])
    @session.fill_in("set_name_description", :with => hash[:description])
  end

  def create
    @session.click_on("Save")
  end
end

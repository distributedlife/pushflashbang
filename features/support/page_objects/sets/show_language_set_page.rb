load 'features/support/page_objects/sets/show_set_page.rb'

module ShowLanguageSetPage
  include ShowSetPage
  
  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}"
  end

  def select_review_mode review_mode
    @session.click_on review_mode
  end
end

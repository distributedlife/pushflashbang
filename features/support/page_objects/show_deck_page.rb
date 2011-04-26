module ShowDeckPage
  def is_get?
    true
  end

  def url id
    "/deck/#{id}"
  end

  def is_current_page?
    @session.has_content?("language code") && @session.has_content?("country code")
  end
end

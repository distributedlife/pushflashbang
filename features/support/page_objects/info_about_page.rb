module InfoAboutPage
  def url *params
    "/"
  end

  def is_current_page?
    @session.has_content?("PushFlashBang") && @session.has_content?("Language learning tools")
  end
end

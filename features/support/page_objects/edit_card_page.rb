module EditCardPage
  def is_get?
    true
  end

  def url *params
    "/deck/#{params[0][0][0][:deck_id]}/card/#{params[0][0][0][:id]}/edit"
  end

  def is_current_page?
    @session.has_content?("Edit Card")
  end

  def front= value
    @session.fill_in('card_front', :with => value)
  end

  def back= value
    @session.fill_in('card_back', :with => value)
  end

  def save_changes
    @session.click_on('Save Changes')
  end

  def delete
    @session.click_on('Delete')
  end

  def front
    @session.find_field('card_front').value
  end

  def back
    @session.find_field('card_back').value
  end
end

module ApplicationHelper
  def edit_link_to *args, &block
    link_to *args, &block if current_user.in_edit_mode?
  end
end
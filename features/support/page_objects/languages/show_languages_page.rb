# -*- encoding : utf-8 -*-
module ShowLanguagesPage
  def is_get?
    true
  end

  def url sut
    "/languages/"
  end

  def is_current_page?
    @session.has_content?("Languages we support").should == true
  end
end

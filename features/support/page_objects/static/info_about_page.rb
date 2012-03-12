# -*- encoding : utf-8 -*-
module SiteIndexPage
  def is_get?
    true
  end
  
  def url sut
    "/"
  end

  def is_current_page?
    @session.has_content?("PushFlashBang").should == true
    @session.has_content?("hello, 你好, hola").should == true
  end
end

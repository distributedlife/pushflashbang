module PagePartsHelper
  def page_header title = "", subtitle = ""
    render :partial => '/common/page_header', :locals => {:title => title, :subtitle => subtitle}
  end

  def section_header title, link = ""
    render :partial => '/common/section_header', :locals => {:title => title, :link => link}
  end

  def loading_text
    render :partial => '/common/loading_text'
  end

  def information header = "", text = "", link = ""
    render :partial => '/alert/information', :locals => {:header => header, :text => text, :link => link}
  end

  def success header = "", text = "", link = ""
    render :partial => '/alert/success', :locals => {:header => header, :text => text, :link => link}
  end

  def null_link text
    link_to text, '#'
  end

  def null_button text
    link_to text, '#', :class => "btn"
  end

  def button text, link, options
    options[:class] = 'btn'

    link_to text, link, options
  end

  def restart_js
    render :partial => '/common/restart_js'
  end
end
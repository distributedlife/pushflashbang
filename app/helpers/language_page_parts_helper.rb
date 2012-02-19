module LanguagePagePartsHelper
  #options[:show_can_change_button] is used to do just that
  def user_languages languages, options = {}
    render :partial => '/languages/user_languages', :locals => {:languages => languages, :show_can_change_button => options[:show_can_change_button]}
  end

  def languages_user_can_learn languages
    render :partial => '/parts/languages_you_can_learn', :locals => {:languages => languages}
  end

  def display_language language, action
    render :partial => '/languages/language', :locals => {:language => language, :action => action}
  end

  def start_learning language
    link_to t('actions.start-learning'), learn_user_language_path(language.id), :method => :post, :id => "language_#{language.id}_start_learning", :class => 'btn'
  end

  def stop_learning language
    link_to t('actions.stop-learning'), unlearn_user_language_path(language.id), :method => :post, :id => "language_#{language.id}_stop_learning", :class => 'btn btn-danger'
  end
end
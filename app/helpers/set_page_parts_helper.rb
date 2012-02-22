module SetPagePartsHelper
  def user_sets
    render :partial => '/sets/user_sets'
  end

  def available_sets
    render :partial => '/sets/available_sets'
  end

  def display_sets sets, user_action = ""
    render :partial => '/sets/sets', :locals => {:language => nil, :sets => sets, :user => false, :user_action => user_action}
  end

  def display_sets_for_selection sets, idiom_id, user_action = ""
    render :partial => '/sets/sets', :locals => {:language => nil, :sets => sets, :user => false, :user_action => user_action, :idiom_id => idiom_id}
  end

  def display_set set, mode
    render :partial => '/sets/set', :locals => {:set => set, :mode => mode}
  end

  def display_set_for_language language, set
    render :partial => '/sets/set_for_language', :locals => {:language => language, :set => set}
  end

  def set_as_goal language, set
    link_to t('actions.set-goal'), set_goal_language_set_path(language.id, set.id), :class => 'btn pull-right', :id => "set_#{set.id}_goal", :method => :put
  end

  def unset_as_goal language, set
    link_to t('actions.unset-goal'), unset_goal_language_set_path(language.id, set.id), :class => 'btn btn-danger pull-right', :id => "set_#{set.id}_goal", :method => :put
  end

  def create_set_button
    edit_link_to t('actions.create-set'), new_set_path, :id => "create_set"
  end

  def link_term_to_set_button set_id
    edit_link_to t('actions.link-term'), select_for_set_set_set_terms_path(set_id), :id => "add_term_to_set_#{set_id}"
  end
  
  def add_term_to_set_button set_id
    edit_link_to t('actions.new-term'), new_set_set_term_path(set_id), :id => "add_term_to_set_#{set_id}"
  end

  def edit_set_button set_id
    edit_link_to t('actions.edit-set'), edit_set_path(set_id), :id => "edit_set_#{set_id}"
  end

  def sets_menu
    render :partial => '/sets/menu'
  end

  def set_menu set_id
    render :partial => '/sets/set_menu', :locals => {:set_id => set_id}
  end

  def review_set_options_button goal
    render :partial => '/sets/review_set_options', :locals => {:language_id => goal.language_id, :set_id => goal.set_id}
  end

  def set_goal_button language_id, set_id
    link_to t('actions.set-goal'), set_goal_language_set_path(language_id, set_id), :class => 'btn', :id => "set_goal", :method => :put
  end

  def unset_goal_button language_id, set_id
    link_to t('actions.unset-goal'), unset_goal_language_set_path(language_id, set_id), :class => 'btn btn-danger', :id => "unset_goal", :method => :put
  end

  def set_user_review_options
    render :partial => '/sets/frame_user_review_options'
  end

  def display_set_name set_name, link, in_edit_mode
    if link
      link_to set_name.name, set_path(set_name.sets_id)
    else
      if in_edit_mode
        on_the_spot_edit set_name, :name
      else
        set_name.name
      end
    end
  end

  def display_set_description set_name, in_edit_mode
    if in_edit_mode
      on_the_spot_edit set_name, :description
    else
      set_name.description
    end
  end

  def display_set_chapters set_id, chapters
    render :partial => '/sets/set_chapters', :locals => {:set_id => set_id, :chapters => chapters}
  end

  def display_chapter set_id, chapter, set_terms = [], start_collapsed = true
    render :partial => '/sets/set_chapter', :locals => {:set_id => set_id, :chapter => chapter, :set_terms => set_terms, :start_collapsed => start_collapsed}
  end

  def chapter_header chapter
    "#{t('text.chapter-prefix')} #{chapter}"
  end

  def select_set set_id, idiom_id
    link_to t('actions.select-set'), add_to_set_set_set_term_path(set_id, idiom_id), :id => "set_#{set_id}_add_term", :method => :put, :class => 'btn'
  end

  def finish_adding_to_set_button set_id
    link_to t('actions.finish-adding-to-set'), set_path(set_id), :class => 'btn btn-danger pull-right'
  end

  def edit_set_button set_id
    link_to content_tag('i', '', :class => 'icon-edit'), edit_set_path(:id => set_id), :class => 'btn'
  end

  def save_set_button form
    form.submit I18n.t('actions.save'), :class => 'btn btn-primary'
  end

  def delete_set_button set_id
    link_to I18n.t('actions.delete-set'), set_path(set_id), :class => 'btn btn-danger', :method => :delete, :id => "set_delete"
  end

  def delete_set_name_button set_id, set_name_id
    link_to content_tag('i', '', :class => 'icon-remove'), delete_set_name_set_path(set_id, :set_name_id => set_name_id), :method => :delete, :id => "set_name_#{set_name_id}_delete"
  end

  def add_set_name_section i
    render :partial => '/sets/add_set_name_div', :locals => {:i => i}
  end

  def add_set_name_button i
    link_to I18n.t('actions.new-set-name'), add_set_name_set_path(:i => i), :class => 'btn', :method => :post, :remote => :true
  end

  def edit_set_section set_name, i
    render :partial => '/sets/create_set_name_form', :locals => {:set_name => set_name, :i => i}
  end
end
module TranslationPagePartsHelper
  def display_translation_as_table_row translation, classname = "", set_id = nil
    render :partial => '/translations/show', :locals => {:translation => translation, :set_id => set_id, :classname => classname}
  end

  def display_translation_audio translation
    render :partial => '/audio_controls_start_only', :locals => {:audio_url => translation.audio.url, :id => translation.id}
  end

  def terms_menu
    render :partial => '/terms/menu'
  end

  def create_term_button
    edit_link_to t('actions.new-term'), new_term_path, :id => "create_term"
  end

  def edit_term_button idiom_id
    link_to content_tag('i', '', :class => 'icon-edit'), edit_term_path(:id => idiom_id), :class => 'btn'
  end

  def add_term_to_set_button idiom_id
    link_to t('actions.add-to-set'), select_term_term_sets_path(idiom_id), :id => "term_#{idiom_id}_add_to_set", :class => 'btn'
  end

  def next_page query, current_page_number
    link_to t('actions.more'), search_terms_path(:q => query, :page => current_page_number + 1), :class => 'btn',  :id => "next_page"
  end

  def search_results_header_row
    render :partial => '/terms/search_results_header_row'
  end

  def search_results_idiom_split_row classname, mode = 'view', idiom_id = nil, set_id = nil
    render :partial => '/terms/search_results_idiom_split_row', :locals => {:classname => classname, :mode => mode, :idiom_id => idiom_id, :set_id => set_id}
  end

  def get_strip idiom_count
    "#{(idiom_count % 2 == 0) ? 'force-stripe' : ''}"
  end

  def show_search_results translations, query, current_page_number, results_per_page_limit, mode, set_id = nil
    render :partial => '/terms/show_search_results', :locals => {:translations => translations, :q => query, :page => current_page_number, :limit => results_per_page_limit, :mode => mode, :set_id => set_id}
  end

  def create_translation_section translation, i, languages
    render :partial => '/terms/create_translation_section', :locals => {:translation => translation, :i => i, :languages => languages}
  end

  def edit_translation_section translation, i, languages
    render :partial => '/terms/edit_translation_section', :locals => {:translation => translation, :i => i, :languages => languages}
  end

  def create_translation_header i
    "#{t('text.header-translation-count')} #{i + 1}"
  end

  def create_term_form translation, i, f, languages
    render :partial => 'create_term_form', :locals => {:translation => translation, :i => i, :f => f, :languages => languages}
  end

  def edit_term_form translation, i, f, languages
    render :partial => 'edit_term_form', :locals => {:translation => translation, :i => i, :f => f, :languages => languages}
  end

  def add_translation_button i
    link_to I18n.t('actions.add-translation'), add_translation_terms_path(:i => i), :class => 'btn', :remote => :true, :id => "add_translation"
  end

  def create_translation_button form
    form.submit I18n.t('actions.create'), :class => 'btn btn-success', :id => "term_create"
  end

  def save_translation_button form
    form.submit I18n.t('actions.save'), :class => 'btn btn-success', :id => "term_save"
  end

  def delete_translation_button form
  end

  def add_translation_section i
    render :partial => '/terms/add_translation_div', :locals => {:i => i}
  end

  def display_pronuciation_guidance translation
    unless translation.pronunciation.blank?
      render :partial => '/translations/pronunciation_guidance', :locals => {:translation => translation}
    end
  end
end
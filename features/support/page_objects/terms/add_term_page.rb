module AddTermPage
  def is_get?
    true
  end

  def url sut
    "/terms/new"
  end

  def is_current_page?
    @session.has_content?("Create a set of related translations").should == true
  end

  def set_translation index, hash
    @session.fill_in("translation_#{index}_form", :with => hash[:form])
    @session.select(hash[:language], :from => "translation_#{index}_language_id")
    @session.fill_in("translation_#{index}_pronunciation", :with => hash[:pronunciation])
  end

  def form_has_hash_contents index, hash
    @session.find_field("translation_#{index}_form").value.should == hash[:form]
    @session.find_field("translation_#{index}_language_id").text[hash[:language]].nil?.should == false unless hash[:language].blank?
#    @session.find_field("translation_#{index}_language_id").text.should == hash[:language] 
    @session.find_field("translation_#{index}_pronunciation").value.should == hash[:pronunciation]
  end

  def add_translation_slot
    @session.click_on("add translation")
  end

  def add_translations
    @session.click_on("Create")
  end
end

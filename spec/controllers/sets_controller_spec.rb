require 'spec_helper'

describe SetsController do
  before(:each) do
    @user = User.make
    sign_in :user, @user
  end
  
  context '"POST" create' do
    it 'should require a valid name to create a set' do
      post :create, :set_name => {:name => "", :description => "Greet some peeps"}

      Sets.count.should == 0
      SetName.count.should == 0
    end

    it 'should create a set and a linked set name' do
      post :create, :set_name => {:name => "Greetings", :description => "Greet some peeps"}

      Sets.count.should == 1
      SetName.count.should == 1

      SetName.first.name.should == "Greetings"
      SetName.first.description.should == "Greet some peeps"
      SetName.first.sets_id.should == Sets.first.id
    end
  end

  context '"GET" show' do
    it 'should return all set names for the specified set' do
      set = Sets.make
      sn1 = SetName.make(:name => 'set name a', :sets_id => set.id, :description => "desc a")
      sn2 = SetName.make(:name => 'set name b', :sets_id => set.id, :description => "desc b")

      get :show, :id => set.id

      assigns[:set_names][0].should == sn1
      assigns[:set_names][1].should == sn2
    end

    it 'should redirect to sets_path when there is an error' do
      get :show, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should return all terms and translations in the set' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")

      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language => "English", :form => "Zebra")
      term2 = Translation.make(:language => "Spanish", :form => "Allegra")
      term3 = Translation.make(:language => "Chinese", :form => "ce")
      term4 = Translation.make(:language => "English", :form => "Hobo")
      term5 = Translation.make(:language => "Spanish", :form => "Cabron")
      term6 = Translation.make(:language => "Spanish", :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      SetTerms.make(:set_id => set.id, :term_id => idiom1.id)

      get :show, :id => set.id

      assigns[:idiom_translations][0].idiom_id.should == idiom1.id
      assigns[:idiom_translations][0].translation.language.should == "Chinese"
      assigns[:idiom_translations][0].translation.form.should == "ce"

      assigns[:idiom_translations][1].idiom_id.should == idiom1.id
      assigns[:idiom_translations][1].translation.language.should == "English"
      assigns[:idiom_translations][1].translation.form.should == "Zebra"

      assigns[:idiom_translations][2].idiom_id.should == idiom1.id
      assigns[:idiom_translations][2].translation.language.should == "Spanish"
      assigns[:idiom_translations][2].translation.form.should == "Cabron"
    end
  end

  context '"GET" index' do
    it 'should return all set names for all sets' do
      set1 = Sets.make
      sn11 = SetName.make(:name => 'set name a', :sets_id => set1.id, :description => "desc a")
      sn12 = SetName.make(:name => 'set name b', :sets_id => set1.id, :description => "desc b")
      set2 = Sets.make
      sn21 = SetName.make(:name => 'set name a', :sets_id => set2.id, :description => "desc a")
      sn22 = SetName.make(:name => 'set name b', :sets_id => set2.id, :description => "desc b")


      get :index
      assigns[:sets][0].should == set1
      assigns[:sets][0].set_name[0].should == sn11
      assigns[:sets][0].set_name[1].should == sn12
      assigns[:sets][1].should == set2
      assigns[:sets][1].set_name[0].should == sn21
      assigns[:sets][1].set_name[1].should == sn22

      assigns[:sets].count.should == 2
    end

    it 'should redirect to sets_path when there is an error' do
      get :index

      response.should be_redirect
      response.should redirect_to user_index_path
    end
  end

  context '"GET" edit' do
    it 'should return all set names for the specified set' do
      set = Sets.make
      sn1 = SetName.make(:name => 'set name a', :sets_id => set.id, :description => "desc a")
      sn2 = SetName.make(:name => 'set name b', :sets_id => set.id, :description => "desc b")

      get :edit, :id => set.id

      assigns[:set_names][0].should == sn1
      assigns[:set_names][1].should == sn2
    end

    it 'should redirect to sets_path when there is an error' do
      get :edit, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end

  context '"PUT" update' do
    before(:each) do
      @set = Sets.make
      @sn1 = SetName.make(:name => 'set name a', :sets_id => @set.id, :description => "desc a")
    end
    
    it 'should create new set names if they are supplied' do
      put :update, :id => @set.id, :set_name =>
        {
          "0" => {
            :id => @sn1.id,
            :name => "set name a",
            :description => "desc a",
          },
          "1" => {
            :name => "a new name",
            :description => "isn't this exciting?"
          }
        }

      Sets.count.should == 1
      SetName.count.should == 2

      SetName.first.should == @sn1
      SetName.last.name.should == "a new name"
      SetName.last.description.should == "isn't this exciting?"
    end

    it 'should update existing set names if they are supplied' do
      put :update, :id => @set.id, :set_name =>
        {
          "0" => {
            :id => @sn1.id,
            :name => "changed name a",
            :description => "changed desc a",
          }
        }

      Sets.count.should == 1
      SetName.count.should == 1

      SetName.first.name.should == "changed name a"
      SetName.first.description.should == "changed desc a"
    end

    it 'should return all changes unsaved if any is invald' do
      put :update, :id => @set.id, :set_name =>
        {
          "0" => {
            :id => @sn1.id,
            :name => "changed name a",
            :description => "changed desc a",
          },
          "1" => {
            :name => "",
            :description => "isn't this exciting?"
          }
        }

      Sets.count.should == 1
      SetName.count.should == 1

      SetName.first.should == @sn1


      put :update, :id => @set.id, :set_name =>
        {
          "0" => {
            :id => @sn1.id,
            :name => "",
            :description => "changed desc a",
          },
          "1" => {
            :name => "el valido",
            :description => "isn't this exciting?"
          }
        }

      Sets.count.should == 1
      SetName.count.should == 1

      SetName.first.should == @sn1
    end
    
    it 'should redirect to sets_path when there is an error' do
      get :edit, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end

  context '"DELETE" delete_set_name' do
    before(:each) do
      @set = Sets.make
      @sn1 = SetName.make(:name => 'set name a', :sets_id => @set.id, :description => "desc a")

      @set2 = Sets.make
      @sn2 = SetName.make(:name => 'w00t sauce', :sets_id => @set2.id, :description => "desc a")

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should redirect to sets page if set is not valid' do
      delete :delete_set_name, :id => @set.id + 1, :set_name_id => @sn1.id

      response.should be_redirect
      response.should redirect_to sets_path

      Sets.count.should == 2
      SetName.count.should == 2
    end

    it 'should redirect to sets page if set name is not valid or does not belong to set' do
      delete :delete_set_name, :id => @set.id, :set_name_id => @sn1.id + 1

      response.should be_redirect
      response.should redirect_to sets_path

      Sets.count.should == 2
      SetName.count.should == 2


      delete :delete_set_name, :id => @set.id, :set_name_id => @sn2.id

      response.should be_redirect
      response.should redirect_to sets_path

      Sets.count.should == 2
      SetName.count.should == 2
    end

    it 'should not allow the deletion of the last set name' do
      delete :delete_set_name, :id => @set.id, :set_name_id => @sn1.id

      response.should be_redirect
      response.should redirect_to :back

      Sets.count.should == 2
      SetName.count.should == 2
    end

    it 'should delete the specified set name' do
      @sn3 = SetName.make(:name => 'second set name', :sets_id => @set.id, :description => "desc a")


      delete :delete_set_name, :id => @set.id, :set_name_id => @sn1.id

      Sets.count.should == 2
      SetName.count.should == 2

      SetName.first.sets_id.should == @set2.id
      SetName.first.name.should == 'w00t sauce'
      SetName.last.sets_id.should == @set.id
      SetName.last.name.should == 'second set name'

      response.should be_redirect
      response.should redirect_to :back
    end
  end

  context '"DELETE" destroy' do
    before(:each) do
      @set = Sets.make
      @sn1 = SetName.make(:name => 'set name a', :sets_id => @set.id, :description => "desc a")

      @set2 = Sets.make
      @sn2 = SetName.make(:name => 'w00t sauce', :sets_id => @set2.id, :description => "desc a")

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should redirect to sets page if set is not valid' do
      delete :delete_set_name, :id => @set.id + 1, :set_name_id => @sn1.id

      response.should be_redirect
      response.should redirect_to sets_path

      Sets.count.should == 2
      SetName.count.should == 2
    end

    it 'should delete the specified set and all associated set names' do
      delete :destroy, :id => @set.id

      Sets.count.should == 1
      SetName.count.should == 1

      Sets.first.id.should ==  @set2.id
      SetName.first.sets_id.should == @set2.id
      SetName.first.name.should == 'w00t sauce'

      response.should be_redirect
      response.should redirect_to :back
    end
  end

  context '"GET" select' do
    it 'should return all set names for all sets' do
      set1 = Sets.make
      sn11 = SetName.make(:name => 'set name a', :sets_id => set1.id, :description => "desc a")
      sn12 = SetName.make(:name => 'set name b', :sets_id => set1.id, :description => "desc b")
      set2 = Sets.make
      sn21 = SetName.make(:name => 'set name a', :sets_id => set2.id, :description => "desc a")
      sn22 = SetName.make(:name => 'set name b', :sets_id => set2.id, :description => "desc b")


      get :select, :idiom_id => 1 
      assigns[:sets][0].should == set1
      assigns[:sets][0].set_name[0].should == sn11
      assigns[:sets][0].set_name[1].should == sn12
      assigns[:sets][1].should == set2
      assigns[:sets][1].set_name[0].should == sn21
      assigns[:sets][1].set_name[1].should == sn22

      assigns[:sets].count.should == 2
    end

    it 'should redirect to sets_path if there are no sets' do
      get :select, :idiom_id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should redirect to user home if idiom_id is not supplied' do
      get :select

      response.should be_redirect
      response.should redirect_to user_index_path
    end
  end

  context '"PUT" add_term' do
    it 'should link the term to the set' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :add_term, :id => set.id, :idiom_id => idiom.id

      SetTerms.count.should == 1
      SetTerms.first.set_id.should == set.id
      SetTerms.first.term_id.should == idiom.id
    end

    it 'should return to user home if the set does not exist' do
      idiom = Idiom.make

      put :add_term, :id => 1, :idiom_id => idiom.id

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should return to the set home if the term does not exist' do
      set = Sets.make

      put :add_term, :id => set.id, :idiom_id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should not add a term twice if it already exists' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)

      put :add_term, :id => set.id, :idiom_id => idiom.id
      put :add_term, :id => set.id, :idiom_id => idiom.id

      SetTerms.count.should == 1
      SetTerms.first.set_id.should == set.id
      SetTerms.first.term_id.should == idiom.id
    end
  end

  context '"PUT" remove_term' do
    it 'should remove the term from the set' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)

      put :remove_term, :id => set.id, :idiom_id => idiom.id

      SetTerms.count.should == 0
    end

    it 'should return to user home if the set does not exist' do
      idiom = Idiom.make

      put :remove_term, :id => 1, :idiom_id => idiom.id

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should return to the set home if the term does not exist' do
      set = Sets.make

      put :remove_term, :id => set.id, :idiom_id => 1

      response.should be_redirect
      response.should redirect_to user_index_path
    end

    it 'should not error a term twice is not linked' do
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")
      idiom = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation1.id)
      idiom_translation = IdiomTranslation.make(:idiom_id => idiom.id, :translation_id => translation2.id)
      set_term = SetTerms.make(:set_id => set.id, :term_id => idiom.id)

      put :remove_term, :id => set.id, :idiom_id => idiom.id
      put :remove_term, :id => set.id, :idiom_id => idiom.id

      SetTerms.count.should == 0
    end
  end

  context '"POST" term_next_chapter' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 2)
    end

    it 'should move the term into the next chapter' do
      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1

      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 2
    end

    it 'should make a new chapter if the next does not exist' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2

      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 3
    end

    it 'should redirect to sets index if set does not exist' do
      post :term_next_chapter, :id => @set.id + 1, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all
      
      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should renormalise the chapters if a chapter is left empty' do
      SetTerms.delete_all
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 2)

      post :term_next_chapter, :id => @set.id, :idiom_id => @idiom4.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom4.id).first.chapter.should be 2
    end
  end

  context '"POST" term_prev_chapter' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      translation1 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation1.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id)


      @idiom2 = Idiom.make
      translation21 = Translation.make(:language => "English", :form => "hello", :pronunciation => "")
      translation22 = Translation.make(:language => "Spanish", :form => "hola", :pronunciation => "")
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => translation21.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => translation22.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 2)
    end

    it 'should move the term into the next chapter' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2

      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
    end

    it 'should make a new chapter if the current chapter is 1 does not exist' do
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2
      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom2.id
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1


      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom2.id

      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 2
    end

    it 'should redirect to sets index if set does not exist' do
      post :term_prev_chapter, :id => @set.id + 1, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom2.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should renormalise the chapters if a chapter is left empty' do
      SetTerms.delete_all
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1)

      post :term_prev_chapter, :id => @set.id, :idiom_id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.chapter.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.chapter.should be 2
    end
  end

  context '"POST" term_next_position' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1, :position => 1)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1, :position => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1, :position => 3)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 1, :position => 4)
    end

    it 'should move the term into the next position, swapping with whatever is there' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1

      post :term_next_position, :id => @set.id, :idiom_id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should not move beyond the last position' do
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4

      post :term_next_position, :id => @set.id, :idiom_id => @idiom4.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should redirect to sets index if set does not exist' do
      post :term_next_position, :id => @set.id + 1, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :term_next_position, :id => @set.id, :idiom_id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :term_next_position, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :term_next_position, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end
  end

  context '"POST" term_prev_position' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @idiom1 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :chapter => 1, :position => 1)

      @idiom2 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :chapter => 1, :position => 2)

      @idiom3 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom3.id, :chapter => 1, :position => 3)

      @idiom4 = Idiom.make
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :chapter => 1, :position => 4)
    end

    it 'should move the term into the next position, swapping with whatever is there' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2

      post :term_prev_position, :id => @set.id, :idiom_id => @idiom2.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should not move beyond the first position' do
      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1

      post :term_prev_position, :id => @set.id, :idiom_id => @idiom1.id

      SetTerms.where(:term_id => @idiom1.id).first.position.should be 1
      SetTerms.where(:term_id => @idiom2.id).first.position.should be 2
      SetTerms.where(:term_id => @idiom3.id).first.position.should be 3
      SetTerms.where(:term_id => @idiom4.id).first.position.should be 4
    end

    it 'should redirect to sets index if set does not exist' do
      post :term_prev_position, :id => @set.id + 1, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to set path if idiom does not exist' do
      post :term_prev_position, :id => @set.id, :idiom_id => @idiom1.id + 1

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path if idiom is not in set' do
      SetTerms.delete_all

      post :term_prev_position, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end

    it 'should redirect to set path on successful completion' do
      post :term_prev_position, :id => @set.id, :idiom_id => @idiom1.id

      response.should be_redirect
      response.should redirect_to set_path(@set.id)
    end
  end
end

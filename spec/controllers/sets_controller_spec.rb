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

      assigns[:user_goal].empty?.should be true
    end

    it 'should redirect to sets_path when there is an error' do
      get :show, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should return all terms and translations in the set' do
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      chinese = Language.create(:name => "Chinese")
      set = Sets.make
      set_name = SetName.make(:sets_id => set.id, :name => "my set", :description => "learn some stuff")

      idiom1 = Idiom.make
      idiom2 = Idiom.make

      term1 = Translation.make(:language_id => english.id, :form => "Zebra")
      term2 = Translation.make(:language_id => spanish.id, :form => "Allegra")
      term3 = Translation.make(:language_id => chinese.id, :form => "ce")
      term4 = Translation.make(:language_id => english.id, :form => "Hobo")
      term5 = Translation.make(:language_id => spanish.id, :form => "Cabron")
      term6 = Translation.make(:language_id => spanish.id, :form => "Abanana")

      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term1.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term2.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term3.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term4.id)
      IdiomTranslation.make(:idiom_id => idiom1.id, :translation_id => term5.id)
      IdiomTranslation.make(:idiom_id => idiom2.id, :translation_id => term6.id)

      SetTerms.make(:set_id => set.id, :term_id => idiom1.id)

      get :show, :id => set.id

      assigns[:idiom_translations][2].idiom_id.should == idiom1.id
      assigns[:idiom_translations][2].translation.language_id.should == chinese.id
      assigns[:idiom_translations][2].translation.form.should == "ce"

      assigns[:idiom_translations][0].idiom_id.should == idiom1.id
      assigns[:idiom_translations][0].translation.language_id.should == english.id
      assigns[:idiom_translations][0].translation.form.should == "Zebra"

      assigns[:idiom_translations][1].idiom_id.should == idiom1.id
      assigns[:idiom_translations][1].translation.language_id.should == spanish.id
      assigns[:idiom_translations][1].translation.form.should == "Cabron"
    end

    it 'should return if the user has the set as a goal' do
      set = Sets.make
      sn1 = SetName.make(:name => 'set name a', :sets_id => set.id, :description => "desc a")
      UserSets.make(:set_id => set.id, :user_id => @user.id)

      get :show, :id => set.id

      assigns[:set_names][0].should == sn1
      assigns[:user_goal].first.set_id.should == set.id
      assigns[:user_goal].first.user_id.should == @user.id
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

      SetName.order(:name).first.sets_id.should == @set.id
      SetName.order(:name).first.name.should == 'second set name'
      SetName.order(:name).last.sets_id.should == @set2.id
      SetName.order(:name).last.name.should == 'w00t sauce'

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
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
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
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
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
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
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
      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
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

      english = Language.create(:name => "English")
      spanish = Language.create(:name => "Spanish")

      @idiom1 = Idiom.make
      translation1 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation2 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation1.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => translation2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id)


      @idiom2 = Idiom.make
      translation21 = Translation.make(:language_id => english.id, :form => "hello", :pronunciation => "")
      translation22 = Translation.make(:language_id => spanish.id, :form => "hola", :pronunciation => "")
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

  context '"PUT" set_goal' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @language = Language.make

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should redirect to sets_path if the set does not exist' do
      put :set_goal, :id => @set.id + 1, :language_id => @language.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to sets_path if the language does not exist' do
      put :set_goal, :id => @set.id + 1, :language_id => @language.id + 1

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should create a user set relationship if one does not already exists' do
      UserSets.count.should be 0

      put :set_goal, :id => @set.id, :language_id => @language.id

      response.should be_redirect
      response.should redirect_to :back
      UserSets.count.should be 1
      UserSets.first.set_id.should == @set.id
      UserSets.first.user_id.should == @user.id
      UserSets.first.language_id.should == @language.id
    end

    it 'should do nothing if the user set relationship already exists' do
      UserSets.make(:set_id => @set.id, :user_id => @user.id, :language_id => @language.id)
      UserSets.count.should be 1

      put :set_goal, :id => @set.id, :language_id => @language.id

      UserSets.count.should be 1
      UserSets.first.set_id.should == @set.id
      UserSets.first.user_id.should == @user.id
      UserSets.first.language_id.should == @language.id
    end
  end

  context '"PUT" unset_goal' do
    before(:each) do
      @set = Sets.make
      SetName.make(:sets_id => @set.id, :name => "my set", :description => "learn some stuff")

      @language = Language.make

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should redirect to sets_path if the set is does not exist' do
      put :unset_goal, :id => @set.id + 1, :language_id => @language.id

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should redirect to sets_path if the set is does not exist' do
      put :unset_goal, :id => @set.id, :language_id => @language.id + 1

      response.should be_redirect
      response.should redirect_to sets_path
    end

    it 'should remove a user set relationship if one already exists' do
      UserSets.make(:set_id => @set.id, :user_id => @user.id, :language_id => @language.id)

      put :unset_goal, :id => @set.id, :language_id => @language.id

      response.should be_redirect
      response.should redirect_to :back
      UserSets.count.should be 0
    end

    it 'should do nothing if the user set relationship does not exist' do
      put :unset_goal, :id => @set.id, :language_id => @language.id

      UserSets.count.should be 0
    end
  end

  context '"GET" review' do
    before(:each) do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
      @language = Language.make   #primary language
      @language2 = Language.make
      @language3 = Language.make
      @language4 = Language.make  #has no terms in set
      @set = Sets.make            #primary set
      @set2 = Sets.make

      #first idiom is in language and set
      @idiom1 = Idiom.make
      t1 = Translation.make(:language_id => @language.id)
      t2 = Translation.make(:language_id => @language2.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => @idiom1.id, :translation_id => t2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom1.id, :position => 1, :chapter => 1)

      #second idiom is not in language but is in set
      @idiom2 = Idiom.make
      t1 = Translation.make(:language_id => @language2.id)
      t2 = Translation.make(:language_id => @language3.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => @idiom2.id, :translation_id => t2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom2.id, :position => 2, :chapter => 1)

      #third idiom is not in set but is in language
      @idiom3 = Idiom.make
      t1 = Translation.make(:language_id => @language.id)
      t2 = Translation.make(:language_id => @language2.id)
      IdiomTranslation.make(:idiom_id => @idiom3.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => @idiom3.id, :translation_id => t2.id)
      SetTerms.make(:set_id => @set2.id, :term_id => @idiom3.id, :position => 1, :chapter => 1)

      #fourth idiom is in language and set
      @idiom4 = Idiom.make
      t1 = Translation.make(:language_id => @language.id)
      t2 = Translation.make(:language_id => @language2.id)
      IdiomTranslation.make(:idiom_id => @idiom4.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => @idiom4.id, :translation_id => t2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiom4.id, :position => 3, :chapter => 1)

      #Nth idiom is in the language and set but in a subsequent chapter
      @idiomN = Idiom.make
      t1 = Translation.make(:language_id => @language.id)
      t2 = Translation.make(:language_id => @language2.id)
      IdiomTranslation.make(:idiom_id => @idiomN.id, :translation_id => t1.id)
      IdiomTranslation.make(:idiom_id => @idiomN.id, :translation_id => t2.id)
      SetTerms.make(:set_id => @set.id, :term_id => @idiomN.id, :position => 1, :chapter => 2)
    end

    it 'should redirect to languages_path if language is invalid' do
      get :review, :language_id => @language.id + 100, :id => @set.id, :review_mode => 'reading'

      response.should be_redirect
      response.should redirect_to languages_path
    end

    it 'should redirect to sets_path if set is invalid' do
      get :review, :language_id => @language.id, :id => @set.id + 100, :review_mode => 'reading'

      response.should be_redirect
      response.should redirect_to language_path(@language.id)
    end

    it 'should redirect to the language_sets_path if the review type is not set or is invalid' do
      get :review, :language_id => @language.id, :id => @set.id

      response.should be_redirect
      response.should redirect_to language_set_path(@language.id, @set.id)

      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'bananas'

      response.should be_redirect
      response.should redirect_to language_set_path(@language.id, @set.id)
    end

    it 'should redirect to the language set page if the set contains no terms for that language' do
      get :review, :language_id => @language4.id, :id => @set.id, :review_mode => 'reading, typing'

      response.should be_redirect
      response.should redirect_to language_set_path(@language4.id, @set.id)
    end
    
    it 'should redirect to the next term in the set for the user if there are no terms due' do
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'reading'

      response.should be_redirect
      response.should redirect_to review_language_set_term_path(@language.id, @set.id, @idiom1.id)
    end

    it 'should schedule the next unscheduled term for the specified review types when there are no due terms' do
      UserIdiomSchedule.count.should == 0
      UserIdiomDueItems.count.should == 0

      start = Time.now
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'reading, typing'
      finish = Time.now

      UserIdiomSchedule.count.should == 1
      UserIdiomSchedule.first.user_id.should == @user.id
      UserIdiomSchedule.first.idiom_id.should == @idiom1.id
      UserIdiomSchedule.first.language_id.should == @language.id

      UserIdiomDueItems.count.should == 2
      UserIdiomDueItems.first.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.first.review_type.should == 1
      UserIdiomDueItems.first.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.first.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.first.interval.should == 5

      UserIdiomDueItems.last.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.last.review_type.should == 4
      UserIdiomDueItems.last.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.last.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.last.interval.should == 5
    end

    it 'should show the next due term for the specified review types if there are due terms' do
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom1.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.ago, :interval => 5)

      UserIdiomSchedule.count.should == 1
      UserIdiomDueItems.count.should == 1

      start = Time.now
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'reading, typing'
      finish = Time.now

      UserIdiomSchedule.count.should == 1
      UserIdiomSchedule.first.user_id.should == @user.id
      UserIdiomSchedule.first.idiom_id.should == @idiom1.id
      UserIdiomSchedule.first.language_id.should == @language.id

      UserIdiomDueItems.count.should == 2
      #reading
      UserIdiomDueItems.first.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.first.review_type.should == 1
      UserIdiomDueItems.first.due.utc.to_s.should <= 1.day.ago.utc.to_s
      UserIdiomDueItems.first.interval.should == 5

      #typing
      UserIdiomDueItems.last.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.last.review_type.should == 4
      UserIdiomDueItems.last.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.last.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.last.interval.should == 5
    end

    it 'should not show due terms that are not due for the specified review types' do
      # our only scheduled item is due for reading but no other review type, as the review mode is typing it should not be shown
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom1.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.ago, :interval => 5)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 2, :due => 1.day.from_now, :interval => 5)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 4, :due => 1.day.from_now, :interval => 5)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 8, :due => 1.day.from_now, :interval => 5)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 16, :due => 1.day.from_now, :interval => 5)

      UserIdiomSchedule.count.should == 1
      UserIdiomDueItems.count.should == 5

      start = Time.now
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'typing'
      finish = Time.now

      UserIdiomSchedule.count.should == 2
      UserIdiomDueItems.count.should == 6

      UserIdiomSchedule.last.user_id.should == @user.id
      UserIdiomSchedule.last.idiom_id.should == @idiom4.id
      UserIdiomSchedule.last.language_id.should == @language.id
      
      UserIdiomDueItems.last.user_idiom_schedule_id.should == UserIdiomSchedule.last.id
      UserIdiomDueItems.last.review_type.should == 4
      UserIdiomDueItems.last.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.last.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.last.interval.should == 5
    end

    it 'should not show terms in the set that do not translate into the language' do
      UserIdiomSchedule.count.should == 0
      UserIdiomDueItems.count.should == 0

      start = Time.now
      get :review, :language_id => @language3.id, :id => @set.id, :review_mode => 'reading, typing'
      finish = Time.now

      UserIdiomSchedule.count.should == 1
      UserIdiomSchedule.first.user_id.should == @user.id
      UserIdiomSchedule.first.idiom_id.should == @idiom2.id
      UserIdiomSchedule.first.language_id.should == @language3.id

      UserIdiomDueItems.count.should == 2
      UserIdiomDueItems.first.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.first.review_type.should == 1
      UserIdiomDueItems.first.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.first.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.first.interval.should == 5

      UserIdiomDueItems.last.user_idiom_schedule_id.should == UserIdiomSchedule.first.id
      UserIdiomDueItems.last.review_type.should == 4
      UserIdiomDueItems.last.due.utc.to_s.should >= start.utc.to_s
      UserIdiomDueItems.last.due.utc.to_s.should <= finish.utc.to_s
      UserIdiomDueItems.last.interval.should == 5
    end

    it 'should redirect to the next chapter in set page if there are no due terms and no terms to schedule' do
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom1.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now, :interval => 5)
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom4.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now, :interval => 5)

      UserIdiomSchedule.count.should == 2
      UserIdiomDueItems.count.should == 2

      start = Time.now
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'reading'
      finish = Time.now

      UserIdiomSchedule.count.should == 2
      UserIdiomDueItems.count.should == 2

      response.should be_redirect
      response.should redirect_to next_chapter_language_set_path(@language.id, @set.id)
    end

    it 'should redirect to the set complete page if there are no due terms, no terms to schedule and no more chapters' do
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom1.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now, :interval => 5)
      schedule = UserIdiomSchedule.create(:idiom_id => @idiom4.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now, :interval => 5)
      schedule = UserIdiomSchedule.create(:idiom_id => @idiomN.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :review_type => 1, :due => 1.day.from_now, :interval => 5)

      UserIdiomSchedule.count.should == 3
      UserIdiomDueItems.count.should == 3

      start = Time.now
      get :review, :language_id => @language.id, :id => @set.id, :review_mode => 'reading'
      finish = Time.now

      UserIdiomSchedule.count.should == 3
      UserIdiomDueItems.count.should == 3

      response.should be_redirect
      response.should redirect_to completed_language_set_path(@language.id, @set.id)
    end
  end
end

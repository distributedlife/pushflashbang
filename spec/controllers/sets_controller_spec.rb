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
      set = Sets.create
      sn1 = SetName.create(:name => 'set name a', :sets_id => set.id, :description => "desc a")
      sn2 = SetName.create(:name => 'set name b', :sets_id => set.id, :description => "desc b")

      get :show, :id => set.id

      assigns[:set_names][0].should == sn1
      assigns[:set_names][1].should == sn2
    end

    it 'should redirect to sets_path when there is an error' do
      get :show, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end

  context '"GET" index' do
    it 'should return all set names for all sets' do
      set1 = Sets.create
      sn11 = SetName.create(:name => 'set name a', :sets_id => set1.id, :description => "desc a")
      sn12 = SetName.create(:name => 'set name b', :sets_id => set1.id, :description => "desc b")
      set2 = Sets.create
      sn21 = SetName.create(:name => 'set name a', :sets_id => set2.id, :description => "desc a")
      sn22 = SetName.create(:name => 'set name b', :sets_id => set2.id, :description => "desc b")


      get :index
      assigns[:sets][0].should == set1
      assigns[:sets][0].set_name[0].should == sn11
      assigns[:sets][0].set_name[1].should == sn12
      assigns[:sets][1].should == set2
      assigns[:sets][1].set_name[0].should == sn21
      assigns[:sets][1].set_name[1].should == sn22
    end

    it 'should redirect to sets_path when there is an error' do
      get :show, :id => 234

      response.should be_redirect
      response.should redirect_to sets_path
    end
  end

  context '"GET" edit' do
    it 'should return all set names for the specified set' do
      set = Sets.create
      sn1 = SetName.create(:name => 'set name a', :sets_id => set.id, :description => "desc a")
      sn2 = SetName.create(:name => 'set name b', :sets_id => set.id, :description => "desc b")

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
      @set = Sets.create
      @sn1 = SetName.create(:name => 'set name a', :sets_id => @set.id, :description => "desc a")
    end
    
    it 'should create new set names if they are supplied' do
      put :update, :id => @set.id, :sets =>
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
      put :update, :id => @set.id, :sets =>
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
      put :update, :id => @set.id, :sets =>
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


      put :update, :id => @set.id, :sets =>
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
end

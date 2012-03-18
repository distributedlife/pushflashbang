# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TranslationsController do
  context '"DELETE" destroy' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      @idiom = Idiom.make!
      @translation1 = Translation.make!(:idiom_id => @idiom.id)
      @translation2 = Translation.make!(:idiom_id => @idiom.id)
      @translation3 = Translation.make!(:idiom_id => @idiom.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should delete the supplied translation if it exists' do
      delete :destroy, :term_id => @idiom.id, :id => @translation1.id

      Translation.where(:id => @translation1.id).empty?.should be true
      Translation.where(:id => @translation2.id).empty?.should be false
      Translation.where(:id => @translation3.id).empty?.should be false

      Translation.count.should == 2
    end

    it 'should redirect to back' do
      delete :destroy, :term_id => @idiom.id, :id => @translation1.id

      response.should be_redirect
      response.should redirect_to(:back)
    end
  end

  context '"POST" attach_and_detach' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      @idiom1 = Idiom.make!
      @idiom2 = Idiom.make!
      @translation1 = Translation.make!(:idiom_id => @idiom1.id)
      @translation2 = Translation.make!(:idiom_id => @idiom1.id)
      @translation3 = Translation.make!(:idiom_id => @idiom1.id)
      @translation4 = Translation.make!(:idiom_id => @idiom2.id)
      @translation5 = Translation.make!(:idiom_id => @idiom2.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should link the translation id to the specified idiom id' do
      post :attach_and_detach, :term_id => @idiom2.id, :id => @translation3.id, :remove_from_idiom_id => @idiom1.id

      Translation.where(:idiom_id => @idiom1.id, :id => @translation1.id).empty?.should be false
      Translation.where(:idiom_id => @idiom1.id, :id => @translation2.id).empty?.should be false
      Translation.where(:idiom_id => @idiom1.id, :id => @translation3.id).empty?.should be true
      Translation.where(:idiom_id => @idiom2.id, :id => @translation3.id).empty?.should be false
      Translation.where(:idiom_id => @idiom2.id, :id => @translation4.id).empty?.should be false
      Translation.where(:idiom_id => @idiom2.id, :id => @translation5.id).empty?.should be false
    end
  end

  context '"POST" attach' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      @idiom1 = Idiom.make!
      @idiom2 = Idiom.make!
      @translation1 = Translation.make!(:idiom_id => @idiom1.id)
      @translation2 = Translation.make!(:idiom_id => @idiom1.id)
      @translation3 = Translation.make!(:idiom_id => @idiom1.id)
      @translation4 = Translation.make!(:idiom_id => @idiom2.id)
      @translation5 = Translation.make!(:idiom_id => @idiom2.id)

      request.env["HTTP_REFERER"] = "http://pushflashbang.com"
    end

    it 'should link the translation id to the specified idiom id' do
      post :attach, :term_id => @idiom2.id, :id => @translation3.id

      Translation.where(:idiom_id => @idiom1.id, :id => @translation1.id).empty?.should == false
      Translation.where(:idiom_id => @idiom1.id, :id => @translation2.id).empty?.should == false
      Translation.where(:idiom_id => @idiom1.id, :id => @translation3.id).empty?.should == false
      Translation.where(:idiom_id => @idiom2.id, :id => @translation4.id).empty?.should == false
      Translation.where(:idiom_id => @idiom2.id, :id => @translation5.id).empty?.should == false
      
      Translation.where(:idiom_id => @idiom2.id, :form => @translation3.form).empty?.should == false
    end
  end
end

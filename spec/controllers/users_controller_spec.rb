require 'spec_helper'

describe UsersController do
  context 'index' do
    it 'should return success' do
      get :index
      
      response.should be_success
    end
  end
end

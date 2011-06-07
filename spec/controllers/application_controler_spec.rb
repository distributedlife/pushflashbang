require 'spec_helper'

describe ApplicationController do
  describe 'resolve_layout_type' do
    it 'should return application if the user agent is not in the MOBILE BROWSERS list' do
      ApplicationController::resolve_layout_type('banana').should == "application"
    end

    it 'should return mobile_application if the user agent is in the MOBILE BROWSERS list' do
      ApplicationController::resolve_layout_type('ipod').should == "mobile_application"
      ApplicationController::resolve_layout_type('banana ipod').should == "mobile_application"
    end

    it 'should return application if the user agent is in the MOBILE BROWSERS list and in the EXCLUSIONS list' do
      ApplicationController::resolve_layout_type('ipad').should == "application"
      ApplicationController::resolve_layout_type('ipad mobile').should == "application"
    end
  end
end
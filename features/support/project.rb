require 'bermuda/cucumber'

#add blueprints path (needed to cuke steps to access blueprints)
require File.expand_path(File.dirname(__FILE__) + "../../../spec/support/blueprints.rb")

#use akephalos for the javascript driver
Capybara.javascript_driver = :akephalos

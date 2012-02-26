require 'bermuda/cucumber'

#add blueprints path (needed to cuke steps to access blueprints)
require File.expand_path(File.dirname(__FILE__) + "../../../spec/support/blueprints.rb")
require File.expand_path(File.dirname(__FILE__) + "../../../spec/support/helpers.rb")

# our test components
Dir[File.dirname(__FILE__) + '/../components/*.rb'].each {|file| require file}

#use akephalos for the javascript driver
Capybara.javascript_driver = :webkit

World(SystemUnderTest)
World(UserComponent)
World(IdiomComponent)
World(TranslationComponent)
World(LanguageComponent)
World(SetComponent)
World(UserIdiomScheduleComponent)


FakeWeb.register_uri(:get, "http://www.google-analytics.com", :body => "", :status => ["404", "Not Found"])
FakeWeb.register_uri(:get, "https://ssl.google-analytics.com", :body => "", :status => ["404", "Not Found"])
require 'bermuda/cucumber'

#add blueprints path (needed to cuke steps to access blueprints)
require File.expand_path(File.dirname(__FILE__) + "../../../spec/support/blueprints.rb")

# our test components
Dir[File.dirname(__FILE__) + '/../components/*.rb'].each {|file| require file}

#use akephalos for the javascript driver
Capybara.javascript_driver = :akephalos

World(SystemUnderTest)
World(UserComponent)
World(IdiomComponent)
World(TranslationComponent)
World(LanguageComponent)
World(SetComponent)


Akephalos.filter(:get, "http://www.google-analytics.com")
Akephalos.filter(:get, "https://ssl.google-analytics.com")
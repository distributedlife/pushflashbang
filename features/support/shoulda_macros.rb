module Paperclip
  module Shoulda
    def stub_paperclip_s3(model, attachment, extension)
      definition = model.gsub(" ", "_").classify.constantize.
                         attachment_definitions[attachment.to_sym]

      path = "http://s3.amazonaws.com/:id/#{definition[:path]}"
      path.gsub!(/:([^\/\.]+)/) do |match|
        "([^\/\.]+)"
      end

      FakeWeb.register_uri(:put, Regexp.new(path), :body => "OK")
    end

    def paperclip_fixture(model, attachment, extension)
      stub_paperclip_s3(model, attachment, extension)
      base_path = File.join(File.dirname(__FILE__), "..", "..",
                            "features", "support", "paperclip")
      File.new(File.join(base_path, model, "#{attachment}.#{extension}"))
    end
  end
end

class ActionController::Integration::Session
  include Paperclip::Shoulda
end

class Factory
  include Paperclip::Shoulda
end
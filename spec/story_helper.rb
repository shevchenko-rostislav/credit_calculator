ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../lib/application.rb', __FILE__

include Rack::Test::Methods

def app
  Application
end

require 'sinatra'
require 'rspec'
require "rspec/expectations"
require 'rack/test'
require 'base64'
require 'json'

def basic_auth(user, pass)
  cred = "#{user}:#{pass}"
  header 'Authorization', "Basic #{Base64.encode64(cred)}"
end

def set_driver(driver)
  $config.driver = driver
  setup_backend
end

module SinatraTest
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

def mock_gen(number)
  post "/debug/gen/#{number}"
  post '/sync'
end

def mock_give(amount, address)
  post "/debug/give/#{amount}/#{address}"
  post '/sync'
end


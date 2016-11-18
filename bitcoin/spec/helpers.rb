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

module SinatraTest
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

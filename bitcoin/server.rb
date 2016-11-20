require 'sinatra'
require 'sinatra/json'
require 'yaml'
require 'rack'
require 'ostruct'

require_relative 'backend'

def load_config
  $config = OpenStruct.new YAML.load_file('config.yml')
end

def setup_backend
  $backend = Backend.new(
    $config.driver,
    $config.send($config.driver),
    $config.redis)
end

load_config

if __FILE__ == $0
  setup_backend
end

use Rack::Auth::Basic, 'auth required' do |user, password|
  user == $config.user and password == $config.password
end

post '/new' do
  json $backend.new_address
end

get '/all' do
  json $backend.get_all
end

get '/info' do
  json({
    driver: $config.driver
  })
end

get '/:address' do
  json $backend.get(params[:address], params[:confirmations])
end

not_found do
  status 404
  json nil
end

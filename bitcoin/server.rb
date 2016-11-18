require 'sinatra'
require 'sinatra/json'
require 'yaml'
require 'rack'

require_relative 'backend'

file_config = YAML.load_file('config.yml')
file_config.each do |k,v|
  if !settings.respond_to? k
    set k, v
  end
end

$backend = Backend.new(
  settings.driver,
  settings.send(settings.driver),
  settings.redis)

use Rack::Auth::Basic, 'auth required' do |user, password|
  user == settings.user and password == settings.password
end

post '/new' do
  json $backend.new_address
end

get '/all' do
  json $backend.get_all
end

get '/info' do
  json({
    driver: settings.driver
  })
end

get '/:address' do
  json $backend.get(params[:address], params[:confirmations])
end

not_found do
  status 404
  json nil
end

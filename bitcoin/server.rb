require 'sinatra'
require 'sinatra/json'
require 'yaml'

require_relative 'store'

#load all backends
Dir['./backends/*'].each do |file|
  require_relative file
end

def get_backend(name)
  begin
    Object.const_get(name.capitalize)
  rescue NameError
    abort "no backend with the name '#{name}'"
  end
end

def load_config
  file_config = YAML.load_file('config.yml')
  file_config.each do |k,v|
    if !settings.respond_to? k
      set k, v
    end
  end
end

load_config

$stats = {
  last_ms: [],
  average_ms: 0,
  start_time: Time.now.to_i,
  backend: settings.backend
}

$backend = get_backend(settings.backend).new settings.send(settings.backend)
$store = Store.new

$syncing = true

def sync_store
  start_time = Time.now
  $backend.sync $store
  end_time = Time.now

  sync_time = ((end_time - start_time) * 1000).round 3

  $stats[:last_ms].push sync_time
  $stats[:average_ms] =
    ($stats[:last_ms].reduce(:+) / $stats[:last_ms].length).round 3

rescue Exception => error
  puts "error occured while syncing: #{error}"
end

Thread.new do
  while $syncing
    sync_store
    sleep settings.sync_frequency
  end
end

use Rack::Auth::Basic, 'auth required' do |user, password|
  user == settings.user and password == settings.password
end

post '/new' do
  address = $backend.new_address
  sync_store
  json address
end

get '/all' do
  json $store.all
end

get '/info' do
  json $stats
end

get '/:address' do
  json $store.get(params[:address], (params[:confirmations] || 0).to_i)
end

not_found do
  status 404
  json nil
end

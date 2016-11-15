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

$stats = {
  last_ms: [],
  average_ms: 0
}

config = YAML.load_file('config.yml')

$backend = get_backend(config['backend']).new config[config['backend']]
$store = Store.new

$syncing = true


def sync_store
  start_time = Time.now
  $backend.sync $store
  end_time = Time.now

  sync_time = ((end_time - start_time) * 1000).round 3

  $stats[:last_ms].pop if $stats[:last_ms].length > 100
  $stats[:last_ms].push sync_time
  $stats[:average_ms] =
    ($stats[:last_ms].reduce(:+) / $stats[:last_ms].length).round 3

rescue Exception => error
  puts "error occured while syncing: #{error}"
end

Thread.new do
  while $syncing
    sync_store
    sleep config['sync_frequency']
  end
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
  result = $store.get(params[:address], (params[:confirmations] || 0).to_i)

  if result.nil?
    status 404
  end

  json result
end

not_found do
  status 404
  json nil
end

require 'sinatra'
require 'json'
require 'rspec'
require 'rack/test'
require 'base64'
require_relative 'helpers'

set :backend, 'mock'
set :user, 'user'
set :password, 'password'

require_relative '../server.rb'

describe 'server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should require authentication for all routes' do
    get '/info'

    expect(last_response).not_to be_ok
    expect(last_response.status).to eq 401

    get '/all'
    expect(last_response.status).to eq 401

    post '/new'
    expect(last_response.status).to eq 401

    post '/address_route_test'
    expect(last_response.status).to eq 401
  end

  it 'should GET basic information from /info' do
    basic_auth 'user', 'password'
    get '/info'

    expect(last_response).to be_ok
    expect(last_response.body).to include '"backend":"mock"'
    expect(last_response.content_type).to eq 'application/json'
  end

  it 'should create a new address from POSTing to /new' do
    basic_auth 'user', 'password'
    post '/new'

    expect(last_response).to be_ok
    expect(last_response.body).to match /"\w{25,35}"/
    expect(last_response.content_type).to eq 'application/json'
  end

  it 'should GET a list of all addresses from /all' do
    basic_auth 'user', 'password'
    get '/all'

    expect(last_response).to be_ok
    expect(last_response.body).to match /\[.*\]/
    expect(last_response.content_type).to eq 'application/json'

    original_length = last_response.body.length

    post '/new'
    new_address = last_response.body

    get '/all'

    expect(original_length).to be < last_response.body.length
    expect(last_response.body).to include new_address
  end

  it 'should GET information about address from /:address' do
    basic_auth 'user', 'password'
    post '/new'
    new_address = last_response.body[1...-1]

    get "/#{new_address}"

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq 'application/json'
    expect(last_response.body).to match /\[.*\]/
    expect(last_response.body).to include 'transactions'
    expect(last_response.body).to include 'balance'
    expect(last_response.body).to include 'confirmations'
  end

  it 'should always GET information from /:address' do
    basic_auth 'user', 'password'
    get '/not_a_real_address'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq 'application/json'
    expect(last_response.body).to eq '{"transactions":[],"balance":"0.0","confirmations":0}'
  end
end

require_relative 'helpers'
require_relative '../server'

describe 'server' do
  include SinatraTest

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
    expect(last_response.content_type).to eq 'application/json'
  end
end

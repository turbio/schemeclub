require_relative 'helpers'
require_relative '../server'

def bitcoind_query(params)
  `bitcoin-cli -rpcuser=user -rpcpassword=password #{params}`

  #give it a second to sync
  post '/sync'
end

describe "bitcoind driver" do
  include SinatraTest

  before do basic_auth 'user', 'password' end
  before(:all) do set_driver 'bitcoind' end

  it 'should be using bitcoind' do
    get '/info'

    expect(JSON.parse(last_response.body)['driver']).to eq 'bitcoind'
  end

  it 'should create a new address from POSTing to /new' do
    post '/new'

    expect(last_response).to be_ok
    expect(last_response.body).to match /"\w{25,35}"/
    expect(last_response.content_type).to eq 'application/json'
  end

  it 'should GET a list of all addresses from /all' do
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
    get '/not_a_real_address'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq 'application/json'
    expect(last_response.body).to eq(
      '{"transactions":[],"balance":"0.0","confirmations":0}')
  end

  it 'should GET new transaction information from /:address' do
    post '/new'
    address = last_response.body[1...-1]

    get "/#{address}"
    res = JSON.parse(last_response.body)
    expect(res).to include 'transactions'
    expect(res['transactions'].length).to eq 0

    bitcoind_query "sendtoaddress #{address} 1.2345678"

    get "/#{address}"
    res = JSON.parse(last_response.body)
    expect(res).to include 'transactions'
    expect(res['transactions'].length).to eq 1

    bitcoind_query "sendtoaddress #{address} 1.2345678"

    get "/#{address}"
    res = JSON.parse(last_response.body)
    expect(res).to include 'transactions'
    expect(res['transactions'].length).to eq 2
  end

  it 'should GET correct balance with confirmations from /:address' do
    post '/new'
    address = last_response.body[1...-1]

    bitcoind_query "sendtoaddress #{address} 1.2345678"

    get "/#{address}"
    expect(JSON.parse(last_response.body)['balance']).to eq '1.2345678'
    expect(JSON.parse(last_response.body)['confirmations']).to eq 0

    get "/#{address}?confirmations=1"
    expect(JSON.parse(last_response.body)['balance']).to eq '0.0'
    expect(JSON.parse(last_response.body)['confirmations']).to eq 1

    bitcoind_query 'generate 1'

    get "/#{address}?confirmations=1"
    expect(JSON.parse(last_response.body)['balance']).to eq '1.2345678'
    expect(JSON.parse(last_response.body)['confirmations']).to eq 1

    get "/#{address}?confirmations=2"
    expect(JSON.parse(last_response.body)['balance']).to eq '0.0'
    expect(JSON.parse(last_response.body)['confirmations']).to eq 2

    bitcoind_query "sendtoaddress #{address} 2"

    get "/#{address}"
    expect(JSON.parse(last_response.body)['balance']).to eq '3.2345678'

    get "/#{address}?confirmations=1"
    expect(JSON.parse(last_response.body)['balance']).to eq '1.2345678'
  end
end

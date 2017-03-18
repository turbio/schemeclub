require 'net/http'

class Bitcoind
  HistoryDepth = 1000

  def initialize(config)
    @config = config
  end

  def new_address
    query('getnewaddress', @config['account'])
  end

  def sync(store)
    transactions = Hash.new do |h,k| h[k] = [] end

    query('listtransactions', @config['account'], HistoryDepth).each do |t|
      transactions[t['address']].push({
        amount: BigDecimal.new(t['amount'].to_s).to_s('f'),
        confirmations: t['confirmations']
      })
    end

    addresses = Hash.new

    query('getaddressesbyaccount', @config['account']).each do |address|
      store.put(address, transactions[address])
    end
  end

  # debug stuff
  def _gen(number) query('generate', number.to_i) end
  def _give(address, amount) query('sendtoaddress', address, amount) end

  private
    def query(method, *params)
      req = Net::HTTP::Post.new('/')
      req.add_field('Content-Type', 'application/json')
      req.basic_auth @config['user'], @config['password']
      req.body = {
        id: 0,
        method: method,
        params: params
      }.to_json

      http = Net::HTTP.start(@config['host'], @config['port'])
      JSON.parse(http.request(req).body)['result']
    end
end

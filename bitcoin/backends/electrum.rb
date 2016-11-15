require 'awesome_print'
require 'bigdecimal'
require_relative '../backend'

class Electrum < Backend
  SatoshiPerBitcoin = BigDecimal.new('100_000_000')
  @@cached_transactions = {}
  @@cached_address_transactions = Hash.new do |h,k| h[k] = [] end

  def new_address
    query('addrequest', 0, '', false, true)['address']
  end

  def sync(store)
    transactions = query('history')

    transactions.select do |t|
      !@@cached_transactions[t['txid']].nil?
    end.each do |t|
      cached = @@cached_transactions[t['txid']]

      if cached[:confirmations] != t['confirmations']
        cached[:confirmations] = t['confirmations']
        cached[:dirty] = true
      end
    end

    transactions.select do |t|
      @@cached_transactions[t['txid']].nil?
    end.each do |t|
      transaction_details = query('deserialize', query('gettransaction', t['txid'])['hex'])
      outputs = transaction_details['outputs'].map do |t_data|
        {
          amount: to_btc(t_data['value']),
          address: t_data['address']
        }
      end

      @@cached_transactions[t['txid']] = {
        dirty: true,
        confirmations: t['confirmations'],
        to: outputs
      }
    end

    @@cached_transactions.values.select do |transaction|
      transaction[:dirty]
    end.each do |transaction|
      transaction[:dirty] = false

      transaction[:to].each do |to|
        @@cached_address_transactions[to[:address]].push({
          confirmations: transaction[:confirmations],
          amount: to[:amount]
        })
      end
    end

    @@cached_address_transactions.each do |address,transactions|
      store.put(address, transactions)
    end
  end

  private
  def to_btc(amount)
    (BigDecimal.new(amount.to_s) / SatoshiPerBitcoin).to_s('f')
  end

  def query(method, *params)
    req = Net::HTTP::Post.new('/')
    req.add_field('Content-Type', 'application/json')
    req.body = {
      id: 0,
      method: method,
      params: params
    }.to_json

    http = Net::HTTP.start(@@config['host'], @@config['port'])
    JSON.parse(http.request(req).body)['result']
  end
end

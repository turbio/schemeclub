require 'bigdecimal'

class Electrum
  SatoshiPerBitcoin = BigDecimal.new('100_000_000')

  def initialize(config)
    @config = config
    @cached_transactions = {}
    @cached_addresses = Hash.new do |h,k| h[k] = [] end
  end

  def stop
    pid = `pidof electrum`

    if pid != ''
      `kill #{pid}`
      sleep 0.5
      stop
    end
  end

  def is_up
    `electrum daemon status` != 'Daemon not running'
  end

  def start
    stop

    `electrum daemon stop`
    spawn('electrum daemon start')

    while !is_up
      sleep 0.5
    end

    `electrum setconfig rpcport #{@config['port']}`
  end

  def new_address
    query('addrequest', 0, '', false, true)['address']
  end

  def sync(store)
    addresses.each do |address,transactions|
      store.put(address, transactions)
    end
  end

  private

  def update_transaction_cache
    # electrum holds data in a what that is not optimal for our purposes
    # each request has a unique address but there is no way to find the balance
    # on a specific address/request
    # to get the information we need (each addresses balance and transactions)
    # first we must list all the transactions (which concert our addresses)
    transactions = query('history')

    # because we're listing every transaction, some of these transactions will
    # have been already cached and in the store.

    # but it's also possible for an existing transaction to have an updated
    # number of confirmations, meaning we'll have to update the cached transaction
    transactions.select do |t|
      # make sure we're only check transactions that have already been cached
      !@cached_transactions[t['txid']].nil?
    end.each do |t|
      cached = @cached_transactions[t['txid']]

      # if the transaction has a different number of confirmations, update
      # that number and mark it as dirty
      if cached[:confirmations] != t['confirmations']
        cached[:confirmations] = t['confirmations']
        cached[:dirty] = true
      end
    end

    # now, with all the uncached transactions, format them correctly and put
    # them in the cache as dirty
    transactions.select do |t|
      # make sure it's not cached
      @cached_transactions[t['txid']].nil?
    end.each do |t|
      # the electrum api is  kinda annoying, in order to get the
      # recipients and balance of a transaction we have to query:
      # transaction txid -> serialized transaction data -> transaction info
      transaction_details = query(
        'deserialize',
        query('gettransaction', t['txid'])['hex'])

      outputs = transaction_details['outputs'].map do |t_data|
        {
          amount: to_btc(t_data['value']),
          address: t_data['address']
        }
      end

      @cached_transactions[t['txid']] = {
        dirty: true,
        confirmations: t['confirmations'],
        to: outputs
      }
    end

  end

  def update_address_cache
    update_transaction_cache

    @cached_transactions.values.select do |transaction|
      transaction[:dirty]
    end.each do |transaction|
      transaction[:dirty] = false

      transaction[:to].each do |to|
        @cached_addresses[to[:address]].push({
          confirmations: transaction[:confirmations],
          amount: to[:amount]
        })
      end
    end

    query('listrequests')
      .map do |req| req['address'] end
      .each do |addr| @cached_addresses[addr] end
  end

  def addresses
    update_address_cache

    @cached_addresses
  end

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

    http = Net::HTTP.start(@config['host'], @config['port'])
    JSON.parse(http.request(req).body)['result']
  end
end

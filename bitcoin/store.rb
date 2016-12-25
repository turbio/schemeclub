require 'redis'
require 'json'
require 'bigdecimal'

AddressPrefix = 'address:'

class Store
  def initialize
    @config = $config['redis']

    @redis = Redis.new(host: @config['host'],
                        port: @config['port'])
    @redis.flushall
  rescue Redis::CannotConnectError
    puts "error connecting to redis at #{@config['host']}:#{@config['port']}, retrying..."
    sleep 1

    retry
  end

  def put(address, transactions)
    @redis.set("#{AddressPrefix}#{address}", JSON.dump({
      transactions: transactions
    }))
  end

  def get(address, confirmations)
    result = @redis.get "#{AddressPrefix}#{address}"

    if result.nil?
      result = {
        transactions: [],
        balance: '0.0'
      }
    else
      result = JSON.parse(result)

      result['balance'] = result['transactions'].select do |t|
        t['confirmations'] >= confirmations
      end.map do |t|
        BigDecimal.new(t['amount'])
      end.reduce(BigDecimal.new(0), :+).to_s('f')
    end

    result['confirmations'] = confirmations

    result
  end

  def all
    @redis.keys("#{AddressPrefix}*").map do |a|
      a[AddressPrefix.length..-1]
    end
  end
end

require 'redis'
require 'json'
require 'bigdecimal'

AddressPrefix = 'address:'

class Store
  def initialize
    @@redis = Redis.new
    @@redis.flushall
  end

  def put(address, transactions)
    @@redis.set("#{AddressPrefix}#{address}", JSON.dump({
      transactions: transactions
    }))
  end

  def get(address, confirmations=0)
    result = @@redis.get "#{AddressPrefix}#{address}"

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
    @@redis.keys("#{AddressPrefix}*").map do |a|
      a[AddressPrefix.length..-1]
    end
  end
end

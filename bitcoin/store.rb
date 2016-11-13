require 'redis'
require 'json'
require 'bigdecimal'

AddressPrefix = 'address:'

class Store
  def initialize
    @@redis = Redis.new
  end

  def put(address, data)
    @@redis.set "#{AddressPrefix}#{address}", JSON.dump(data)
  end

  def get(address, confirmations=0)
    result = @@redis.get "#{AddressPrefix}#{address}"

    return nil if result.nil?

    result = JSON.parse(result)

    result['balance'] = result['transactions'].select do |t|
      t['confirmations'] >= confirmations
    end.map do |t|
      BigDecimal.new(t['amount'])
    end.reduce(BigDecimal.new(0), :+).to_s('f')

    result['confirmations'] = confirmations

    result
  end

  def all
    @@redis.keys("#{AddressPrefix}*").map do |a|
      a[AddressPrefix.length..-1]
    end
  end
end

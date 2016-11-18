require 'net/http'
require 'bigdecimal'

class Mock
  def initialize(config)
    @config = config
  end

  def start
    @addresses = {}
  end

  def new_address
    new_address = gen_address

    @addresses[new_address] = []

    new_address
  end

  def sync(store)
    @addresses.each do |addr,info|
      store.put(addr, info)
    end
  end

  private
    def gen_address
      range = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a
      (0..34).to_a.map do |t| range.sample end.join
    end
end

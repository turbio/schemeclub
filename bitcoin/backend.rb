require_relative 'store'

#load all drivers
Dir['./drivers/*'].each do |file| require_relative file end

class Backend
  def initialize(driver, driver_config, store_config)
    @store = Store.new

    driver_class = get_driver driver
    @driver = driver_class.new driver_config

    @driver.start
    Thread.new do start_syncing end
  end

  def new_address() @driver.new_address ensure sync_store end
  def get_all() @store.all end
  def get(addr, conf=0) @store.get(addr, conf.to_i) end

  private

  def start_syncing
    @syncing = true
    @driver.start

    while @syncing
      sync_store
      sleep settings.sync_frequency
    end
  end

  def sync_store
    start_time = Time.now
    @driver.sync @store
    end_time = Time.now

    ((end_time - start_time) * 1000).round 3
  rescue Exception => error
    puts "error occured while syncing: #{error}"
  end

  def get_driver(name)
    Object.const_get(name.capitalize)
  rescue NameError
    abort "no driver with the name '#{name}'"
  end
end

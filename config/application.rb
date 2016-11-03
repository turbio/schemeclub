require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Skeem
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    config.analytics = Rails.application.config_for(:analytics)
    config.payment = Rails.application.config_for(:payment)
  end
end

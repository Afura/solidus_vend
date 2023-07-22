# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusVend
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_vend'

    config.to_prepare do
      SolidusVend::BrandSubscriber.new.subscribe_to(Spree::Bus)
      SolidusVend::UserSubscriber.new.subscribe_to(Spree::Bus)
      SolidusVend::VariantSubscriber.new.subscribe_to(Spree::Bus)
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

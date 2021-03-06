# frozen_string_literal: true

SolidusVend.configure do |config|
  config.access_token   = 'VEND_CLIENT_SECRET'
  config.domain_prefix = 'VEND_DOMAIN_PREFIX'
  config.stock_location  = 'STOCKLOCATION_CODE'
end
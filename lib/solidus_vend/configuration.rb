# frozen_string_literal: true
require 'vend'

module SolidusVend
  class Configuration
    attr_accessor(
      :access_token,
      :domain_prefix,
      :stock_location,
    )
  end

  def intiliaze
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end

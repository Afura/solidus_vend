
module SolidusVend
  class SyncVariant < ApplicationService
  
    attr_reader :variant, :client

    def initialize(variant)
      @variant = variant
    end

    def call
      begin
        response = Vend::Product.create(variant)
      rescue => error
        OpenStruct.new({success?: false, error: error, response: response})
      else
        OpenStruct.new({success?: true, response: response})
      end
    end

  end
end

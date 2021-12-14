module SolidusVend
  class SyncResource < ApplicationService
  
    attr_reader :resource, :client

    def initialize(resource)
      @resource = resource
      @client = SolidusVend::Client.new
    end

    def call
      begin
        response = perform
      rescue => error
        OpenStruct.new({success?: false, error: error, response: response})
      else
        OpenStruct.new({success?: true, response: response})
      end
    end

    # private

    def perform
      if resource.vend_id
        response = "Vend::#{self.vend_resource_name}".constantize.update(resource.vend_id, serialized_payload)
      else
        response = "Vend::#{self.vend_resource_name}".constantize.create(serialized_payload)
      end

      if response.success?
        # variant.update(vend_last_sync: Time.now)
        resource.update(vend_id: resource.response.id) if !resource.vend_id
      end
    end

    def vend_resource_name
      resource.class.name.demodulize
    end

    def serialized_payload
      "SolidusVend::#{resource.class.name.demodulize}Serializer".constantize.call(resource)
    end

    # def resource_processor
    #   "SolidusVend::#{resource_name.to_s.classify}Resource".constantize
    # end

    # def processor_exists
    #   # cannot use const_defined because of lazy loading it seems
    #   Object.const_get("Irs::#{resource_name}")
    # rescue NameError => e
    #   errors.add(:adapter_name, 'does not have an IrsAdapter')
    # end

  end
end

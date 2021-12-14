module SolidusVend
  class DeleteVariantJob < ApplicationJob
    queue_as :default
   
    def perform(resource, payload)
      Vend::Customer.destroy(event.payload[:payload].vend_id)
    end
  end
end
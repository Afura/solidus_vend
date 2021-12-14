module SolidusVend
  class DeleteProductJob < ApplicationJob
    queue_as :default
   
    def perform(resource, payload)
      Vend::Product.destroy(event.payload[:payload].vend_id)
    end
  end
end
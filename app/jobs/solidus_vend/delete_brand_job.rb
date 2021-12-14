module SolidusVend
  class DeleteBrandJob < ApplicationJob
    queue_as :default
   
    def perform(resource, payload)
      Vend::Brand.destroy(event.payload[:payload].vend_id)
    end
  end
end
# module Spree
#    module VendVariantSubscriber
#       include Spree::Event::Subscriber
   
#       RESOURCES.each |resource| do
#          event_action :resource_created, event_name: :sync_resource
#          event_action :resource_updated, event_name: :sync_resource
#          event_action :resource_destroyed, event_name: :destroy_resource
#       end
   
#       def sync_resource(event)
#          resource = event.payload[:payload]
#          request = SolidusVend::SyncResource::RESOURCE.call(variant)
         
#          if request.success
#             # variant.update(vend_last_sync: Time.now)
#             resource.update(vend_id: request.response.id) if !resource.vend_id
#          end
#       end

#       def destroy_resource(event)
#          return if !event.payload[:payload].vend_id
#          Vend::RESOURCE.destroy(event.payload[:payload].vend_id)
#       end

#    end
#  end
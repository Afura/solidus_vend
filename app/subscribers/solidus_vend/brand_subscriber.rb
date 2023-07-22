module Spree
   module VendBrandSubscriber
      include Omnes::Subscriber

      handle :brand_created, with: :sync_brand
      handle :brand_updated, with: :sync_brand
      handle :brand_destroyed, with: :destroy_brand
   
      def sync_brand(event)
         SolidusVend::SyncBrand.perform_later(event.payload[:payload])
      end

      def destroy_brand(event)
         SolidusVend::DeleteBrandJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end

#  module Spree
#    module VendVariantSubscriber
#       include Omnes::Subscriber
   
#       RESOURCES.each do |resource|
#          handle :resource_created, with: :sync_resource
#          handle :resource_updated, with: :sync_resource
#          handle :resource_destroyed, with: :destroy_resource
#       end
   
#       def sync_resource(event)
#          resource = event.payload[:payload]
#          request = SolidusVend::SyncResource::RESOURCE.call(resource)
         
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
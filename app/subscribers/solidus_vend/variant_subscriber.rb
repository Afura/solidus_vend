module Spree
   module VendVariantSubscriber
      include Omnes::Subscriber
   
      handle :variant_created, with: :sync_product
      handle :variant_updated, with: :sync_product
      handle :variant_destroyed, with: :destroy_product
   
      def sync_product(event)
         SolidusVend::SyncProductJob.perform_later(event.payload[:payload])
      end

      def destroy_product(event)
         SolidusVend::DeleteProductJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end
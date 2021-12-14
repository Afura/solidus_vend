module Spree
   module VendVariantSubscriber
      include Spree::Event::Subscriber
   
      event_action :variant_created, event_name: :sync_product
      event_action :variant_updated, event_name: :sync_product
      event_action :variant_destroyed, event_name: :destroy_product
   
      def sync_product(event)
         SolidusVend::SyncProductJob.perform_later(event.payload[:payload])
      end

      def destroy_product(event)
         SolidusVend::DeleteProductJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end
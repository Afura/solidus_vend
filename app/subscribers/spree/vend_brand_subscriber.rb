module Spree
   module VendBrandSubscriber
      include Spree::Event::Subscriber
   
      event_action :brand_created, event_name: :sync_brand
      event_action :brand_updated, event_name: :sync_brand
      event_action :brand_destroyed, event_name: :destroy_brand
   
      def sync_brand(event)
         SolidusVend::SyncBrand.perform_later(event.payload[:payload])
      end

      def destroy_brand(event)
         SolidusVend::DeleteBrandJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end
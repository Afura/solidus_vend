module Spree
   module VendUserSubscriber
      include Spree::Event::Subscriber
   
      event_action :user_created, event_name: :sync_customer
      event_action :user_updated, event_name: :sync_customer
      event_action :user_destroyed, event_name: :delete_customer
   
      def sync_customer(event)
         SolidusVend::SyncCustomer.perform_later(event.payload[:payload])
      end

      def delete_customer(event)
         SolidusVend::DeleteCustomerJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end
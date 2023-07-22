module Spree
   module VendUserSubscriber
      include Omnes::Subscriber
   
      handle :user_created, with: :sync_customer
      handle :user_updated, with: :sync_customer
      handle :user_destroyed, with: :destroy_customer
   
      def sync_customer(event)
         SolidusVend::SyncCustomer.perform_later(event.payload[:payload])
      end

      def destroy_customer(event)
         SolidusVend::DeleteCustomerJob.perform_later(event.payload[:payload]) if event.payload[:payload].vend_id
      end

   end
 end
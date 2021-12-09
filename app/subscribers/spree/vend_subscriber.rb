module Spree
   module VendSubscriber
      include Spree::Event::Subscriber
   
      event_action :variant_created
      event_action :variant_updated
      event_action :variant_destroyed
   
      def variant_created(event)
         # Spree::SendcloudLogger.debug("Sending #{event.payload[:shipment].number} to Sendcloud")
         binding.pry
         SolidusVend::SyncVariant.call(event.payload[:payload])
      end

      def variant_updated(event)
         binding.pry
         SolidusVend::SyncVariant.call(event.payload[:payload])
      end

      def variant_destroyed(event)
         binding.pry
         SolidusVend::SyncVariant.call(event.payload[:payload])
      end

      def test
         puts "test"
      end

   end
 end
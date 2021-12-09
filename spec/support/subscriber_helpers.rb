module TestingSupport
   module SubscriberHelpers
     def perform_subscribers(only: [])
       Spree::Config.events.subscriber_registry.deactivate_all_subscribers
 
       Array(only).each(&:activate)
 
       yield
     ensure
       reinitialize_subscribers(RSpec.current_example)
     end
 
     private
 
     def reinitialize_subscribers(example)
       Spree::Config.events.subscriber_registry.deactivate_all_subscribers
 
       if example.metadata[:type].in?(%i[system feature request])
         Spree::Config.events.subscriber_registry.activate_all_subscribers
       end
     end
   end
 end
 
 RSpec.configure do |config|
   config.include TestingSupport::SubscriberHelpers
   config.before do |example|
     reinitialize_subscribers(example)
   end
 end
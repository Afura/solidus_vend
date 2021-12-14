module SolidusVend
  class SyncCustomerJob < ApplicationJob
    queue_as :default
   
    def perform(resource)  
      SolidusVend::CustomerResource.call(resource)
    end
  end
end
module SolidusVend
  class SyncProductJob < ApplicationJob
    queue_as :default
   
    def perform(resource)  
      SolidusVend::ProductResource.call(resource)
    end
  end
end
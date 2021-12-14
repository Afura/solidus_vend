module SolidusVend
  class SyncBrandJob < ApplicationJob
    queue_as :default
   
    def perform(resource)  
      SolidusVend::BrandResource.call(resource)
    end
  end
end
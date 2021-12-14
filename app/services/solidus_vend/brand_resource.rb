module SolidusVend
  class BrandResource < SyncResource
    def serialized_payload
      { name: resource.name }
    end
  end
end

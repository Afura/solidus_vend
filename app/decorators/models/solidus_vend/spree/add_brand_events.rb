module SolidusVend
   module Spree
      module AddBrandEvents
         def self.prepended(base)
            base.after_commit :brand_created, on: :create
            base.after_commit :brand_updated, on: :update
            base.after_commit :brand_destroyed, on: :destroy
         end

         def brand_created
            Spree::Bus.publish :brand_created, brand: self
         end

         def brand_updated
            return unless self.saved_changes?
            Spree::Bus.publish :brand_updated, brand: self
         end

         def brand_destroyed
            Spree::Bus.publish :brand_destroyed, brand: self
         end
            
         ::Spree::Brand.prepend self
      end
   end
end
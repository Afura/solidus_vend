module SolidusVend
   module Spree
      module AddVariantEvents
         def self.prepended(base)
            base.after_commit :variant_created, on: :create
            base.after_commit :variant_updated, on: :update
            base.after_commit :variant_destroyed, on: :destroy
         end

         def variant_created
            Spree::Bus.publish :variant_created, variant: self
         end

         def variant_updated
            return unless self.saved_changes?
            Spree::Bus.publish :variant_updated, variant: self
         end

         def variant_destroyed
            Spree::Bus.publish :variant_destroyed, variant: self
         end
            
         ::Spree::Variant.prepend self
      end
   end
end
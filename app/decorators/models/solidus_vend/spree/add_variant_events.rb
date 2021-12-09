module SolidusVend
   module Spree
      module AddVariantEvents
         def self.prepended(base)
            base.after_commit :variant_created, on: :create
            base.after_commit :variant_updated, on: :update
            base.after_commit :variant_destroyed, on: :destroy
         end

         def variant_created
            binding.pry
            ::Spree::Event.fire 'variant_created', variant: self
         end

         def variant_updated
            # return if self.saved_changes?
            ::Spree::Event.fire 'variant_updated', variant: self
         end

         def variant_destroyed
            binding.pry
            ::Spree::Event.fire 'variant_destroyed', variant: self
         end
            
         ::Spree::Variant.prepend self
      end
   end
end
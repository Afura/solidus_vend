module SolidusVend
   module Spree
      module AddUserEvents
         def self.prepended(base)
            base.after_commit :user_created, on: :create
            base.after_commit :user_updated, on: :update
            base.after_commit :user_destroyed, on: :destroy
         end

         def user_created
            Spree::Bus.publish :user_created, variant: self
         end

         def user_updated
            return unless self.saved_changes?
            Spree::Bus.publish :user_updated, variant: self
         end

         def user_destroyed
            Spree::Bus.publish :user_destroyed, variant: self
         end
            
         ::Spree::User.prepend self
      end
   end
end
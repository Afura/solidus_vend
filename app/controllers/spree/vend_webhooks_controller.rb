module Spree
   class VendWebhooksController < BaseController
      skip_before_action :verify_authenticity_token
      # before_action :validate_payload, only: [:receive]

      def receive
         # TODO: Use Solidus_Webhooks instead
         begin
            payload = JSON.parse(request.body.read, symbolize_names: true)
            method = "handle_" + payload[:root][:type].tr('.', '_')
            self.send method, payload[:root][:payload]
         rescue JSON::ParserError => e
            render json: {:status => 400, :error => "Invalid payload"} and return
         rescue NoMethodError => e
            render json: {:status => 400, :error => "Invalid request"} and return
         end
         render json: {:status => 200}
      end
      
      def handle_customer_update(payload)
         user = Spree::User.find_by(vend_id: payload[:id])

         if user
            user.update({ email: payload[:email]})
         else
            generated_password = Devise.friendly_token.first(8)

            Spree::User.create!({
               :email => payload[:email], 
               :password => generated_password, 
               :password_confirmation => generated_password 
            })
         end
      end

      def handle_product_update(payload)
         # Enforce overwriting the product again
         # Update the product in Solidus
         # Do nothing
      end

      def handle_sale_update(payload)
         stock_mutations = payload[:register_sale_products]
         stock_location  = Spree::StockLocation.find_by(code: SolidusVend.configuration.stock_location)

         # TODO: Add Vend_ID to Spree:StockItems
         stock_mutations.each do |product|
            variant     = Spree::Variant.find_by(vend_id: product[:id])

            if variant
               stock_item  = Spree::StockItem.find_by(variant_id: variant.id, stock_location: stock_location.id)
               quantity    = product[:quantity]
   
               Spree::StockMovement.create!({stock_item: stock_item, quantity: quantity, originator_type: "Vend POS"})
            else
               puts "Could not find product by vend_id" 
            end
            
         end
        
      end

      private

      def validate_payload
         signature = request.headers['X-Signature'] || ''
         digest = OpenSSL::Digest.new('sha256')
         expected = OpenSSL::HMAC.hexdigest(digest, SolidusVend.configuration.client_secret, request.body.read)

         head :forbidden unless Rack::Utils.secure_compare(expected, signature)
      end
   end
end
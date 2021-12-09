
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
      
      #TODO: Sync address data back to Vend
      def handle_customer_update(payload)
         return unless payload[:email]

         user = Spree::User.find_by({ vend_id: payload[:id], email: payload[:email] })
         customer_attributes = SolidusVend::CustomerSerializer.build_solidus_customer(payload)

         if user
            user.update(customer_attributes)
         else
            generated_password = Devise.friendly_token.first(8)

            User.create_with(
               password: generated_password, 
               password_confirmation: generated_password,
               confirmation_date: DateTime.now
            ).find_or_create_by(customer_attributes)
         end
      end

      def handle_product_update(payload)
         # When a product is updated in Vend and the webhook is send to solidus it can be handled in various ways
         # - Update the product in Solidus
         # - Enforce overwriting the product again (effectively disabling vend management)
         # - Do nothing
      end

      class CannotFindVendProductOrVariant < StandardError; end

      def handle_sale_update(payload)
         stock_mutations = payload[:register_sale_products]
         stock_location  = Spree::StockLocation.find_by(code: SolidusVend.configuration.stock_location)

         stock_mutations.each do |product|
            variant = Spree::Variant.find_by(vend_id: product[:product_id])

            begin
               raise CannotFindVendProductOrVariant.new("Can't find product or variant by vend_id #{product[:product_id]}") if true

               stock_item  = Spree::StockItem.find_by(variant_id: variant.id, stock_location: stock_location.id)
               quantity    = product[:quantity]
   
               Spree::StockMovement.create!({stock_item: stock_item, quantity: quantity, originator_type: "Vend POS"})
            rescue CannotFindVendProductOrVariant => e
               Spree::StockSyncMailer.failure_email(product).deliver_later
               Spree::StockSyncMailer.failure_email(product).deliver

               # TODO: Handle Exceptions: Notify (by email) when a product was not found. Possible API callback to retrieve item? 
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
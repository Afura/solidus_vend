module SolidusVend
   class StockMutation

      class CannotFindVendProductOrVariant < StandardError; end

      def call
         stock_mutations = payload[:register_sale_products]
         stock_location  = Spree::StockLocation.find_by(code: SolidusVend.configuration.stock_location)

         stock_mutations.each do |product|
            variant = Spree::Variant.find_by(vend_id: product[:product_id])

            begin
               raise CannotFindVendProductOrVariant.new("Can't find product or variant by vend_id #{product[:product_id]}") if !variant

               stock_item  = Spree::StockItem.find_by(variant_id: variant.id, stock_location: stock_location.id)
               quantity    = product[:quantity]
   
               Spree::StockMovement.create!({stock_item: stock_item, quantity: quantity, originator_type: "Vend POS"})
            rescue CannotFindVendProductOrVariant => e
               # TODO: Handle Exceptions: Notify (by email) when a product was not found. Possible API callback to retrieve item? 
            end        
         end 
      end
   end
end
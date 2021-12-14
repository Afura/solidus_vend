module SolidusVend
   class CustomerSerializer

      def initialize(variant)
         @variant = variant
      end
       
      class << self
 
         def build_vend_customer(user)
            hash = {
               email: user.email
            }
            hash[:customer_code] = user.id if user.id
            hash[:vend_id] = user.vend_id if user.vend_id
            hash
         end

         # 'physical_address1'   => payload[:shipping_address][:address1],
         # 'physical_address2'   => payload[:shipping_address][:address2],
         # 'physical_postcode'   => payload[:shipping_address][:zipcode],
         # 'physical_city'       => payload[:shipping_address][:city],
         # 'physical_state'      => payload[:shipping_address][:state],
         # 'physical_country_id' => payload[:shipping_address][:country],
         
         # 'postal_address1'     => payload[:billing_address][:address1],
         # 'postal_address2'     => payload[:billing_address][:address2],
         # 'postal_postcode'     => payload[:billing_address][:zipcode],
         # 'postal_city'         => payload[:billing_address][:city],
         # 'postal_state'        => payload[:billing_address][:state],
         # 'postal_country_id'   => payload[:billing_address][:country]

         def build_solidus_customer(vend_customer) 
            parse_vend_customer(vend_customer)
         end

         private
 
         def parse_vend_customer(vend_customer)
            {
               vend_id:       vend_customer[:id],
               email:         vend_customer[:email]
            }
            # .merge(name_attributes(vend_customer))
         end

         def name_attributes(vend_customer)
            # if SolidusSupport.combined_first_and_last_name_in_address?
            if true
               { 
                  name: [vend_customer[:first_name], vend_customer[:last_name]].join(' ')
               }
            else
               { firstname: vend_customer[:first_name], lastname: vend_customer[:last_name]}
            end
         end

         def parse_shipping_address(vend_customer)
            {
               address1:  vend_customer[:physical_address1],
               address2:  vend_customer[:physical_address2],
               zipcode:   vend_customer[:physical_postcode],
               city:      vend_customer[:physical_city],
               country:   Spree::Country.find_by!(iso: vend_customer[:physical_country_id]),
               phone:     vend_customer[:phone]
            }
         end
 
         def parse_billing_address(vend_customer)
            {
               address1:  vend_customer[:postal_address1],
               address2:  vend_customer[:postal_address2],
               zipcode:   vend_customer[:postal_postcode],
               city:      vend_customer[:postal_city],
               state:     vend_customer[:postal_state],
               country:   vend_customer[:postal_country_id],
               phone:     vend_customer[:phone]
            }
         end
      end
   end
 end
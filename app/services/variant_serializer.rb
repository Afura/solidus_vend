module SolidusVend
   class VariantSerializer < ApplicationService
    attr_reader :variant

      def initialize(variant)
        @variant = variant
      end

      def call
        {
          source_id: variant.product.id,
          source_variant_id: variant.id,
          handle: variant.product.sku || variant.product.id,
  
          type: '', # Not implemented
          tags: '', # Not implemented

          sku: variant.sku,
          name: vend_product_name,
          brand_name: variant.brand_name,
          description: variant.description,
          supplier_code: variant.style_code,

          supply_price: variant.cost_price.to_f,
          retail_price: variant.price.to_f,

          active: variant.available?,
          track_inventory: variant.track_inventory
        }.merge **variant_options, **vend_product_id
      end

      private

      def vend_product_id
        variant.vend_id ? variant.vend_id : {}
      end

      # Joins an arrat of values by seperator leaving out nil values.
      #
      # @return [String]
      def vend_product_name(seperator: " - ")
        [variant.name, variant.color].select(&:present?).join(seperator)
      end

      # Creates a key value pair out of the variant's (sorted) option values.
      #
      # @return [Hash]
      def variant_options
        variant.option_values_variants.each_with_object({}).with_index do |(item, options_hash), index|
          break if index > 2

          options_hash.merge!({ "variant_option_#{%w(one two three)[index]}_name": item.option_value.option_type.presentation, "variant_option_#{%w(one two three)[index]}_value": item.option_value.presentation })
        end
      end

      # Finds the the genderless top taxonomy (Apparel, Footwear, Accessories, Life).
      #
      # @return [String] string describing the genderless top taxonomy.
      def product_type
        # Apparel / Footwear / Life / Accessories
      end
      
      # Create a list of tags from non root taxons, filter color and gender
      #
      # @return [Array] array of product tags as strings.
      def product_tags
        # Filter Color
        # All descendants
        # Gender
      end

      # Return the Products Vend equivelant of its main tax component
      #
      # @return [String]
      def tax_name
        "BTW Hoog"
      end

    end
  end

module SolidusVend
   class Client
      attr_reader :domain_prefix, :access_token
      
      def initialize
         Vend.configure do |config|
            config.domain_prefix = SolidusVend.configuration.domain_prefix
            config.access_token = SolidusVend.configuration.access_token
         end
      end
   end
end
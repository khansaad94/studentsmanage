module ActionView
  module Helpers
    module TagHelper
      def tag_options_with_data_encrypted_name(options, escape = true)
        if options['data-encrypted-name']
          options['data-encrypted-name'] = options.delete("name")
        end
        tag_options_without_data_encrypted_name(options, escape)
      end

      alias_method_chain :tag_options, :data_encrypted_name
    end
  end
end

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = "fkd8bmztpwghmbfc"
Braintree::Configuration.public_key = 't8yjc7dt7c5gjwdg'
Braintree::Configuration.private_key = '387ac32f8109566c2c9dd04f4aec4bd4'
#Braintree::Configuration.client_side_encryption_key = 'MIIBCgKCAQEAu+QU/asiBsLnkaduG9fbSz8Y/KbwIsE6sinJg8z2XfEtecNMYRAvxAU/5qWWsK3InYgyG8fv96Z8W8uAfBDtNQHRfBkUVYukVYhb6aXjGiyw3HQkypX7XneLhZ6CVYg0ImPospR0i0E6VzSp/QqI+x+JycmqRN0T+8LlvvqL5Z7B+d7/dabTDIDZP6gP95oXEaRP'

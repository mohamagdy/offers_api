module ApiResponseValidator
  module InstanceMethods
    ActiveResource::Connection.class_eval do
      include HashKeyGenerator

      def get_with_check(path, headers = {})
        response = get_without_check(path, headers)

        # Checking if the response and the sign match
        check_signed_response(response)
      end
      alias_method_chain :get, :check

      # Check the signed response and if valid returns the response
      # else it throws an InvalidSignedResponse exception
      def check_signed_response(response)
        if valid_response?(response)
          response
        else
          raise InvalidSignedResponse
        end
      end

      # Check if the response is valid and returns a boolean
      def valid_response?(response)
        signature_header = Rails.application.secrets.api["signature_header"]
        generate_hash_key(response.body) == response[signature_header]
      end
    end
  end

  def self.included(base)
    base.extend InstanceMethods
  end

  class InvalidSignedResponse < StandardError; end
end
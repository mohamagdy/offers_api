module ApiCredentials
  module ClassMethods
    include HashKeyGenerator

    def collection_path_with_auth(*args)
      # Building up the default mandatory params of the API
      params = args.reduce(:merge) || {}

      params.merge!({ "timestamp" => Time.now.to_i })

      params.merge!(Rails.application.secrets.api["credentials"])

      # Generating the hash after concatenating all the params
      params.merge!({ "hashkey" => generate_hash_key(params) })

      # Replacing the query params in args
      args = args[0...-1] << params

      collection_path_without_auth(*args)
    end
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods

      class << self
        alias_method_chain :collection_path, :auth
      end
    end
  end
end
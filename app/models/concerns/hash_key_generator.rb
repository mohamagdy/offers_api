module HashKeyGenerator
  def generate_hash_key(params)
    api_key = Rails.application.secrets.api['key']

    stringified_params = if params.is_a?(Hash)
      # Sorting the params' keys alphabetically
      params = Hash[params.sort_by { |key, _| key.to_s }]

      # 1. Concating params and joing with "&"
      # 2. Concating concatened params with API Key
      Rack::Utils.build_query(params) + "&#{api_key}"
    else
      # Concatenating the API key with the resposne string
      params + api_key
    end

    # SHA1 hashing
    Digest::SHA1.hexdigest(stringified_params)
  end
end
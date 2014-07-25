module HashKeyGenerator
  def generate_hash_key(params)
    # Sorting the params' keys alphabetically
    params = Hash[params.sort_by { |key, _| key.to_s }]

    # Concating params and joing with "&"
    stringified_params = Rack::Utils.build_query(params)

    # Concating concatened params with API Key
    stringified_params += "&#{Rails.application.secrets.api['key']}"

    # SHA1 hashing
    Digest::SHA1.hexdigest(stringified_params)
  end
end
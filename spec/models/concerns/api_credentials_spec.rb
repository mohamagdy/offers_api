require "rails_helper"
require "active_resource"

RSpec.describe ApiCredentials do
  context "default params" do
    it "should include all the default mandatory params required by the API" do
      klass = Class.new(ActiveResource::Base) do
        include ApiCredentials

        def self.model_name
          ActiveModel::Name.new(self, nil, self.class.name)
        end

        self.site = Rails.application.secrets.api["site"]
      end

      request_params = Rack::Utils.parse_query(URI(klass.collection_path).query)

      # Checking the existane of timestamp and hashkey in the params
      expect(request_params).to include("timestamp")
      expect(request_params).to include("hashkey")

      # Checking default params except for the hashkey and timestamp
      expect(
        request_params.except("hashkey", "timestamp")
      ).to eq(Rails.application.secrets.api["credentials"])
    end
  end
end

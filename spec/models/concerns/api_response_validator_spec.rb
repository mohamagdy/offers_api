require "rails_helper"
require "active_resource"

RSpec.describe ApiResponseValidator do
  context "response validation" do
    include ApiResponseValidator

    let(:site) { "http://api.site.com" }
    let(:path) { "/dummy" }
    let(:connection) { ActiveResource::Connection.new(site) }
    let(:body) { "dummy" }

    it "should raise an exception" do
      signed_response = Digest::SHA1.hexdigest("#{body}#{Rails.application.secrets.api['key']}")
      stub_request(:get, "#{site}#{path}").to_return(
        status: 200,
        body: body,
        headers: { Rails.application.secrets.api["signature_header"] => signed_response }
      )

      response = connection.get(path)

      expect{ connection.get(path) }.to_not raise_error
    end

    it "should not raise an exception" do
      signed_response = Digest::SHA1.hexdigest("#{body}")
      stub_request(:get, "#{site}#{path}").to_return(
        status: 200,
        body: body,
        headers: { Rails.application.secrets.api["signature_header"] => signed_response }
      )

      expect{ connection.get(path) }.to raise_error(ApiResponseValidator::InvalidSignedResponse)
    end
  end
end

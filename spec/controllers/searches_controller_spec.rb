require 'rails_helper'

RSpec.describe SearchesController, :type => :controller do
  include HashKeyGenerator

  let(:body) do
    {
      count: 1,
      offers: [
        {
          title: "Offer title",
          payout: "payout",
          thumbnail: {
            lower: "lower thumbnail",
            hires: "hires thumbnail"
          }
        }
      ],
    }.to_json
  end

  let(:signed_response) { generate_hash_key(body) }

  let(:valid_params) do
    { uid: "player1", page: 1, pub0: "campaign1" }
  end

  before do
    stub_request(:get, "#{Offer.site.host}#{Offer.collection_path(valid_params)}").to_return(
      status: 200,
      body: body,
      headers: { Rails.application.secrets.api["signature_header"] => signed_response }
    )
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    it "returns http success" do
      post :create, valid_params
      expect(response).to be_success

      expect(assigns(:offers).count).to eq(1)
    end
  end

end

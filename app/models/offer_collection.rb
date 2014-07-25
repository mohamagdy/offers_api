# Parsing the customized response from Fyber API
class OfferCollection < ActiveResource::Collection
  def initialize(response = {})
    @elements = response["offers"]
  end
end
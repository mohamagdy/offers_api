require "active_resource"

class Offer < ActiveResource::Base
  # Including the module building the API call URL
  include ApiCredentials
  include ApiResponseValidator

  # Setting the API configurations
  self.site = Rails.application.secrets.api["site"]
  self.format = Rails.application.secrets.api["format"].to_sym
  self.collection_parser = OfferCollection
end

class SearchesController < ApplicationController
  # GET /search/new
  def new
  end

  # POST /search
  def create
    @offers = Offer.where(
      uid: params[:uid],
      pub0: params[:pub0],
      page: params[:page]
    )
  end
end

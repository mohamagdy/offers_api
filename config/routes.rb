Rails.application.routes.draw do
  root to: "search#new"

  resource :search, only: [:new, :create]
end

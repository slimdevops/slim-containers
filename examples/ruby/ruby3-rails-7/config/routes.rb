Rails.application.routes.draw do

  defaults format: :json do
      resources :hello, only: [:index]
  end
end

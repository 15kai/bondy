Rails.application.routes.draw do
  root 'home#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :surveys, only: [:show, :create] do
    collection do
      get :complete
    end
  end
end

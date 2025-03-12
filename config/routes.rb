Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "activities", to: "activities#index"
  get "activities/:id", to: "activities#show", as: :activity

  resources :activities do
    resources :favorites, only: [:create] do
      collection do
        post :toggle
      end
    end
  end

  resources :favorites, only: [:destroy]

  get "/planning", to: "pages#planning"
  get "favorites" => "favorites#index"
  patch "/slots/:id", to: "slots#update", as: :update_slot
end

Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  resources :activities, only: [:index]
  resources :favorites, only: [:index, :destroy]

  get "/planning", to: "pages#planning"
  patch "/slots/:id", to: "slots#update", as: :update_slot

  resources :activities, only: [:show] do
    resources :favorites, only: [:create] do
      collection do
        post :toggle
      end
    end
  end
end

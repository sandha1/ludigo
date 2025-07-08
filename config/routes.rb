Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"
  get "/planning", to: "pages#planning"

  resources :slots, only: [:update] do
    member do
      patch :reset
    end
  end

  resources :activities, only: [:index, :show] do
    resources :favorites, only: [:create] do
      collection do
        post :toggle
        post :toggle_show
      end
    end
  end

  resources :favorites, only: [:index, :destroy]
end

Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  resources :activities, only: [:index]
  resources :favorites, only: [:index, :destroy]
  resources :slots, only: [:update]

  get "/planning", to: "pages#planning"
  patch "/slots/reset/:id", to: "slots#reset", as: :reset_slot
  # patch "/slots/update:id", to: "slots#update", as: :update_slot

  resources :activities, only: [:show] do
    resources :favorites, only: [:create] do
      collection do
        post :toggle
        post :toggle_show
      end
    end
  end
end

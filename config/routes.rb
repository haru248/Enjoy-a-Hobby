Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  root 'static_pages#top'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'mypage', to: 'mypages#index'

  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]
  resource :profile, only: %i[show edit update create] do
    get 'password_reset', on: :collection
  end
  resources :presets do
    resources :item_categories, only: %i[index create update destroy]
    resources :preset_items, only: %i[new create edit update destroy]
  end
  resources :inventory_lists do
    get 'use', on: :member
    resources :property_categories, only: %i[index create update destroy]
    resources :properties, only: %i[new create edit update destroy]
    resources :use_presets, only: %i[index show update]
  end
  resources :purchase_lists do
    resources :purchases, only: %i[new create edit update destroy]
  end
end

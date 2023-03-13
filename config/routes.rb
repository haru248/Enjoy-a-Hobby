Rails.application.routes.draw do
  get 'profiles/edit'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  get 'password_resets/edit'
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get 'mypage', to: 'mypages#index'
  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]
  resource :profile, only: %i[show edit update new create]
end

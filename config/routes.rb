Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :skills, only: [:index, :show]
  resources :user_skills, only: [:show, :create, :new, :destroy, :edit, :update] do
    resources :bookings, only: [:new, :create]
    post "description", to: "user_skills#create"
  end
  resources :bookings, only: [:show, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end
  resources :chatrooms, only: [:show] do
    resources :messages, only: [:create]
  end
  get "dashboard", to: "pages#dashboard"
  post "dashboard", to: "pages#dashboard"
  get "how_it_works", to: "pages#how_it_works"
end

Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/home/about' => 'homes#about', as: 'about'
  get 'search' => 'searches#search'
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update, :index] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end
end

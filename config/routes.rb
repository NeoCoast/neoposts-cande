# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index] do
    member do
      get :following, :followers
    end
  end
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'posts#index'
  resources :posts, only: %i[show new create index]
  resources :relationships, only: [:create, :destroy]
  get '/:nickname', to: 'users#show', as: 'user_show'
end

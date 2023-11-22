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
  resources :likes, only: [:create, :destroy]
  resources :posts, only: %i[new create index] do
    resources :comments, only: [:create]
  end
  resources :comments , only: [:create] do
    resources :comments, only: [:create]
  end
  resources :posts, only: %i[new create index] do
    resources :likes, only: [:create], on: :member
    delete '/likes', to: 'likes#destroy', on: :member, as: :post_likes_destroy
  end
  resources :comments, only: %i[create] do
    resources :likes, only: [:create], on: :member
    delete '/likes', to: 'likes#destroy', on: :member, as: :comment_likes_destroy
  end
end

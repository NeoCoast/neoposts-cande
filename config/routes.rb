# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index]
  get '/:nickname', to: 'users#show', as: 'user_show'
  devise_for :users
  root to: 'posts#index'
  resources :posts, only: %i[show new create index]
end

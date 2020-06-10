# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'auth', path_names: { sign_in: 'login',
                                                 sign_out: 'logout',
                                                 sign_up: 'register' }

  resources :admin, only: %i[index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  resources :products, except: %i[destroy]

  resources :cart, only: %i[index] do
    collection do
      get :content, format: :json
      post :add_product
      post :remove_product
      post :checkout
    end
  end

  resources :orders, only: %i[index]

  root to: 'products#index'
end

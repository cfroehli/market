Rails.application.routes.draw do
  devise_for :users, path: 'auth', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'}

  resources :admin, only: [:index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  root to: "users#dashboard"
end

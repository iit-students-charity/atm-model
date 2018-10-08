Rails.application.routes.draw do
  resources :users, only: :show do
    member do
      get 'password'
    end
  end
end

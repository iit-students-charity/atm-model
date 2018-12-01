Rails.application.routes.draw do
  root 'users#index'

  scope :users do
    post 'card_number_check', to: 'users#card_number_check'
  end

  resources :users do
    member do
      get 'pin'
      get 'main_screen'
      get 'take_cash'
      get 'put_cash'
      get 'transaction'
      post 'pin_check'
      post 'update_take_cash'
      post 'update_put_cash'
      post 'update_transaction'
    end
  end
end

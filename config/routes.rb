Rails.application.routes.draw do
  scope :users do
    get 'insert_card', to: 'users#insert_card'
    post 'card_number_check', to: 'users#card_number_check'
  end

  resources :users, only: [:show, :update] do
    member do
      get 'pin'
      get 'main_screen'
      get 'take_cash'
      get 'put_cash'
      get 'transaction'
      post 'pin_check'
    end
  end
end

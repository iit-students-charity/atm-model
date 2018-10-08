Rails.application.routes.draw do
  resources :users, only: [:show, :update] do
    member do
      get 'pin'
      get 'main_screen'
      get 'take_cash'
      get 'put_cash'
      get 'transaction'
      post 'pin_check'
      post 'card_number_check'
    end
  end
  scope :users do
    get 'insert_card', to: 'users#insert_card'
  end
end

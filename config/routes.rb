Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, only: [:create]
    post 'login', to: 'sessions#create'
    post 'lend', to: 'transactions#create_lend_transaction'
    post 'payback', to: 'transactions#create_payback_transaction'
    get 'check_for', to: 'users#status'
    get 'check_between', to: 'transactions#check_between'
  end
end

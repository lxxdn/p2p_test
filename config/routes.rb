Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, only: [:create]
    post 'login', to: 'sessions#create'
    post 'borrow', to: "transactions#create_borrow_transaction"
  end
end

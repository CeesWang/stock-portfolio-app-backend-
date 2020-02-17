Rails.application.routes.draw do
  resources :users
  post 'signup', to: 'users#signup', as: 'signup'
  post 'login', to: 'users#login', as: 'login'
  post 'buy-stocks', to: 'users#trade_stocks', as: 'buy_stocks'
  get 'users/:id/transactions', to: 'users#transactions', as: 'transactions'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

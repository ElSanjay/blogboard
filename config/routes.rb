Rails.application.routes.draw do

  get 'test/index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'home/index'

  get 'leaderboards', to: 'leaderboards#show'

  root to: "home#index"
end

Rails.application.routes.draw do

  get 'authentications', to: 'authentications#show'
  get 'authentications/auth'
  get 'authentications/api_update'
  get 'authentications/auto_update'

  get 'test/index'

  get 'test/callback'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'home/index'

  get 'leaderboards', to: 'leaderboards#show'

  root to: "home#index"
end

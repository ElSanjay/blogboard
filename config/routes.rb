Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get 'authentications', to: 'authentications#show'
  get 'authentications/auth'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'leaderboards', to: 'leaderboards#show'
  get 'organic-search-leaderboards', to: 'leaderboards#show_organic'
  get 'social-leaderboards', to: 'leaderboards#show_social'
  get 'email-leaderboards', to: 'leaderboards#show_email'
  get 'direct-leaderboards', to: 'leaderboards#show_direct'
  get 'paid-leaderboards', to: 'leaderboards#show_paid'

  root to: "leaderboards#show"
end

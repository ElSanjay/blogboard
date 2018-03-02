Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get 'authentications', to: 'authentications#show'
  get 'authentications/auth'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'leaderboards/:board', to: 'leaderboards#show', as: :leaderboards
  get 'organic-search-leaderboards/:board', to: 'leaderboards#show_organic', as: :organic_search_leaderboards
  get 'social-leaderboards/:board', to: 'leaderboards#show_social', as: :social_leaderboards
  get 'email-leaderboards/:board', to: 'leaderboards#show_email', as: :email_leaderboards
  get 'direct-leaderboards/:board', to: 'leaderboards#show_direct', as: :direct_leaderboards
  get 'paid-leaderboards/:board', to: 'leaderboards#show_paid', as: :paid_leaderboards

  root to: "leaderboards#show", board: "this_month"
end

Rails.application.routes.draw do
  devise_for :users
  get 'home/index'

  get 'leaderboards', to: 'leaderboards#show'

  root to: "home#index"
end

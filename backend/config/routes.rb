Rails.application.routes.draw do
  namespace :api do
    resources :teams, only: %i[index create show]
    resources :players, only: %i[index create]
  end
end

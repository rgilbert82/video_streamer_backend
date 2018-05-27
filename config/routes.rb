Rails.application.routes.draw do
  namespace :api do
    resources :users,    only: [:show]
    resources :videos,   only: [:index,  :show]
    resources :comments, only: [:create, :show]

    get '/videos/:id/stats', to: 'videos#stats'
  end
end

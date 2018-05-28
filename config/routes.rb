Rails.application.routes.draw do
  namespace :api do
    resources :users,    only: [:show]
    resources :videos,   only: [:index,  :show]
    resources :comments, only: [:create]

    get '/videos/:id/stats',   to: 'videos#stats'
    get '/chats/:id/comments', to: 'comments#chat_index'
  end
end

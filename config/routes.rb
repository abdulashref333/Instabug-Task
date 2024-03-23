Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # Applications routes
      post '/applications', to: 'applications#create'
      get '/applications/:token', to: 'applications#show', as: :application
      patch '/applications/:token', to: 'applications#update'

      # Chats routes
      post '/applications/:token/chats', to: 'chats#create'
      get '/applications/:token/chats', to: 'chats#index'
      get '/applications/:token/chats/:number', to: 'chats#show', as: :chat

      # Messages routes
      post '/applications/:token/chats/:number/messages', to: 'messages#create'
      get '/applications/:token/chats/:number/messages', to: 'messages#index'
      get '/applications/:token/chats/:number/messages/:number', to: 'messages#show', as: :message
      patch '/applications/:token/chats/:number/messages/:number', to: 'messages#update'
    end
  end
end

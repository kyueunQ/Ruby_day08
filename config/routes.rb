Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get '/tweet' => 'tweet#index'
    get '/tweet/new' => 'tweet#new'
    get 'tweet/:id' => 'tweet#show'
    post'/tweet/create' => 'tweet#create'
    
    get '/tweet/:id/edit' => 'tweet#edit'
    post '/tweet/:id/update' => 'tweet#update'
    get '/tweet/:id/destroy' => 'tweet#destroy'
end

Rails.application.routes.draw do
  post '/register', to: "user#create"
  post '/login', to: "authentication#login"
  patch '/update', to: "user#update"
  get '/show', to: "user#show" 
end

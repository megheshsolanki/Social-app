Rails.application.routes.draw do

  root "user#index"
  post '/register', to: "user#create"
  post '/login', to: "authentication#login"
  patch '/update', to: "user#update"
  post '/verification', to: "user#verify"
  get '/show', to: "user#show" 

  get '/article', to: "article#get_all"
  get '/article/page', to: "article#index"
  get '/article/:id' , to: "article#show"
  post '/article', to: "article#create"
  patch '/article/:id', to: "article#update"
  delete '/article/:id', to: "article#destroy"
  
  get '/article/:id/comment' , to: "comment#show_all"
  post '/article/:id/comment', to: "comment#create"
  patch '/article/:article_id/comment/:id', to: "comment#update"
  delete '/article/:article_id/comment/:id', to: "comment#destroy"

  post '/like/article/:article_id', to: "like#like_article"
  post '/like/comment/:comment_id', to: "like#like_comment"

  get "/notifications", to:'notification#show'
  post "/create_friend", to:'friendship#create'
  post "/friendship/accept/:to_accept", to:'friendship#accept'
  post '/friendship/decline/:to_decline', to:'friendship#decline'
  
  post "/forgot_password", to:'forgot_password#create'
  post "/password_reset", to: "forgot_password#update"
  
end

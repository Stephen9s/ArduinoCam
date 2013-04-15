ArduinoSecuCam::Application.routes.draw do
 
  resources :snapshots

  match "/webcam/left" => "webcam#left"
  match "/webcam/right" => "webcam#right"
  match "/webcam/close" => "webcam#close"
  match "/webcam/refreshSnapshot" => "webcam#refreshSnapshot"
  match "/webcam/closeCamera" => "webcam#closeCamera"
  match "/webcam/startCamera" => "webcam#startCamera"
  get "/gallery/removePhoto/:id" => "gallery#removePhoto"
  
  match "/gallery/index" => "gallery#index"
  
  root :to => "sessions#login"
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "login_attempt", :to => "sessions#login_attempt"
  match "logout", :to => "sessions#logout"
  match "home", :to => "sessions#home"
  match "histogram", :to => "analysis#index"
  
  resources :users
  get "users/new"
  match "/users/:user" => "users#create"
  
end

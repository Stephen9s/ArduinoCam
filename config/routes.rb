ArduinoSecuCam::Application.routes.draw do
  get "users/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  
  resources :snapshots

  match "/webcam/left" => "webcam#left"
  match "/webcam/right" => "webcam#right"
  match "/webcam/close" => "webcam#close"
  match "/webcam/refreshSnapshot" => "webcam#refreshSnapshot"
  #match "/webcam/cameraOps" => "webcam#cameraOps"
  match "/webcam/closeCamera" => "webcam#closeCamera"
  match "/webcam/startCamera" => "webcam#startCamera"
  match "/gallery/removePhoto" => "gallery#removePhoto"
  
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
  
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

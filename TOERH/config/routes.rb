
TOERH::Application.routes.draw do

  # Api namespace
  scope module: "api" do
    # Api subdomain api.*.*
    constraints(:subdomain => 'api', defaults: {format: 'json'}) do
      # Api versioning
      # Version 1.0
      namespace :v1 do
        resource :user, only: [:show]  
        resources :resources, except: [:edit]
        resources :licenses, :resource_types, :tags, only: [:index, :show]  
      end
    end
  end

  # Developers namespace
  scope module: "developers" do
    
    # Developers subdomain
    constraints(:subdomain => 'developers') do
      root 'developers#index' 

      get 'docs' => 'docs#index'
      get 'docs/users' => 'docs#users', :as => 'doc_users'
      get 'docs/auth' => 'docs#auth', :as => 'doc_auth'
      get 'docs/resources' => 'docs#resources', :as => 'doc_resources'

      scope module: "users" do
        get   'register' => 'registrations#new', :as => 'register'
        post  'register' => 'registrations#create', :as => 'registerPost'
        get   'login' => 'authorizations#show', :as => 'login'
        post  'login' => 'authorizations#login', :as => 'loginPost'
        get   'logout' => 'authorizations#logout', :as => 'logout'
      end

      namespace :admin do
        resources :applications, only: [:index, :edit, :update], :controller => "applications"
        get   '' => 'admins#index', :as => 'home'
      end

      resources :applications
    end
  end
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  #   
     

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

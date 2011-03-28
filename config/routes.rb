ActionController::Routing::Routes.draw do |map|

  map.resources :job_applications
  
  map.resources :educations,      :except => [:show]
  map.resources :position_types,  :except => [:show]
  map.resources :business_types,  :except => [:show]
  map.resources :job_categories,  :except => [:show]
    
  map.resource :user_session

  map.with_options :controller => 'user_sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  
  map.register '/register/:id', :controller => 'users', :action => 'new'

  # RESOURCE / RESOURCES -- hide the ID!!!
  #map.resource :account, :controller => "users"
  #map.resource :users
  map.resources :accounts, :controller => "users", :member => { :toggle_active => :get }

  map.resources :job_seekers,       :only => [:index,:show, :update] do |m|
    m.resources :job_histories,     :only => [:create, :destroy]
    m.resources :experiences,       :only => [:create, :destroy]
    m.resources :resumes,           :only => [:edit,:update]
  end

  map.resources :employers, :only => [:index,:show], :collection => { :pending => :get }, :member => { :confirm => :post, :decline => :post, :assign_subpath => :put }
  map.resources :jobs, :member => {:applicants => :get}
  map.resource  :contact, :controller => "contact", :only => [:show], :collection => { :submit => :post } 
  map.welcome '/welcome', :controller => "users", :action => "show"
  map.root :controller => "jobs"
  
  map.subpath ':subpath' , :controller => 'jobs' , :action => 'subpath'

  #plugin: translate  
  #Translate::Routes.translation_ui(map) #if RAILS_ENV != "production"
  
  #plugin: translate-routes
  ActionController::Routing::Translator.i18n

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # map.home '', :controller => 'home', :action => 'dashboard'
  # map.with_options :controller => 'sessions'  do |m|
  #   m.login  '/login',  :action => 'new'
  #   m.logout '/logout', :action => 'destroy'
  # end
  
end

  
 

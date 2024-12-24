Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/", to: "products#index"
  get "/products", to: "products#index"
  get '/products/:slug', to: 'products#show', as: 'product'

  get "/signup",  to: "signup#index", as: 'signup'

  post '/captcha/generate-challenge', to: 'captcha#generate_challenge', as: 'captcha_generate'
  post '/captcha/verify-challenge', to: 'captcha#verify_challenge', as: 'verify_challenge'



  get "/cart",  to: "cart#index", as: 'cart'
  post "/cart",  to: "cart#add_to_cart", as: 'add_to_cart'
  post "/cart/checkout",  to: "cart#checkout", as: 'checkout'
  get "/cart/checkout",  to: "cart#checkout", as: 'checkout_get'



  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

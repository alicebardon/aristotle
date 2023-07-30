Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get 'index', to: 'pages#index'
  get 'startups', to: 'startups#index'
  get "download_logos", to: "startups#download_logos"
end

Rails.application.routes.draw do
  namespace :api do
    get "status", to: "status#show"
    get "home", to: "home#index"
    resources :users, only: [ :index, :show, :create, :update, :destroy ]
    resources :recipes, only: [ :index, :show, :create, :update, :destroy ]
    resources :categories, only: [ :index, :show, :create, :update, :destroy ]
    resources :ingredients, only: [ :index, :show, :create, :update, :destroy ]
    resources :allergies, only: [ :index, :show, :create, :update, :destroy ]
    resources :utensils, only: [ :index, :show, :create, :update, :destroy ]
    resources :comments, only: [ :index, :show, :create, :update, :destroy ]
    resources :shopping_lists, only: [ :index, :show, :create, :update, :destroy ]
    resources :shopping_list_items, only: [ :index, :show, :create, :update, :destroy ]
    resources :steps, only: [ :index, :show, :create, :update, :destroy ]
    resources :step_images, only: [ :index, :show, :create, :update, :destroy ]
    resources :recipe_images, only: [ :index, :show, :create, :update, :destroy ]
    resources :recipe_ingredients, only: [ :index, :show, :create, :update, :destroy ]
    resources :recipe_subrecipes, only: [ :index, :show, :create, :update, :destroy ]
    resources :user_recipe_likes, only: [ :index, :show, :create, :update, :destroy ]
    resources :user_saved_recipes, only: [ :index, :show, :create, :update, :destroy ]
    resources :follows, only: [ :index, :show, :create, :update, :destroy ]
    resources :blocks, only: [ :index, :show, :create, :update, :destroy ]

    namespace :auth do
      post "register", to: "registrations#create"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
      get "me", to: "me#show"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

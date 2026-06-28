Rails.application.routes.draw do
  get "searches/index"
  get "searches/new"
  get "searches/show"
  post "searches/analyze", to: "searches#analyze"
  devise_for :users
  root to: "searches#index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :searches, only: [:index, :create, :new, :show, :destroy, :edit, :update] do
    resources :candidates, only: [:index, :create, :destroy]
  end
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

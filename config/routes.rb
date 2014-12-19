Rails.application.routes.draw do
  root 'index#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get 'map/schedule'
  get 'map/places'

  resources :travels do
    resources :travel_photos, as: 'photos', path: 'photos'
  end
  resources :schedules do
    member do
      patch 'update_memo'
    end
  end
  resources :users
  resources :places do
    collection do
      get 'search'
    end
  end
end

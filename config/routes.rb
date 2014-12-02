Rails.application.routes.draw do
  root 'index#index'

  get 'map/schedule'
  get 'map/places'

  resources :travels do
    member do
      get 'edit_photo'
    end
  end
  resources :travel_photos
  resources :schedules
  resources :users
  resources :places do
    collection do
      get 'search'
    end
  end
end

Rails.application.routes.draw do
  root 'index#index'

  resources :travels
  resources :schedules
  resources :users
  resources :places do
    collection do
      get 'search'
    end
  end
end

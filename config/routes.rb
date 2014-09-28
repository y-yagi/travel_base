Rails.application.routes.draw do
  root 'index#index'

  resources :places do
    collection do
      get 'search'
    end
  end
  resources :users
end

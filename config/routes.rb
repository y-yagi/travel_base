class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  get 'static_page/index' if Rails.env.development?

  get '/search', to: 'search#index'

  root 'index#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/terms', to: 'terms#index'
  get '/privacy', to: 'privacy#index'

  namespace :map do
    get 'schedule'
    get 'places'
    get 'place/:id', action: :place, as: :place
  end

  resources :travels do
    resources :travel_members, only: [:new, :destroy], as: 'members', path: 'members'
    resources :dropbox_files, only: [:destroy], as: 'dropbox_files', path: 'dropbox_files'
    resources :todos, only: [:index, :create, :destroy, :update], as: 'todos', path: 'todos'
  end

  resources :schedules do
    member do
      patch 'update_memo'
    end
    resources :routes
  end
  resources :users
  resources :places do
    member do
      patch :archive
    end

    collection do
      get 'search'
    end
  end
  resources :events
  mount PgHero::Engine, at: "pghero"

  draw :api
end

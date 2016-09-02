use_doorkeeper do
  skip_controllers :applications, :authorized_applications
end

namespace :api do
  namespace :v1 do
    resources :travels, only: %i(index show)
    resources :places, only: %i(index create update destroy show)
    resources :deleted_data, only: %i(index)
    resources :events, only: %i(index)
    resource :user, only: %i(show)
    patch 'user/registrate_token'
  end
end

use_doorkeeper do
  skip_controllers :applications, :authorized_applications
end

namespace :api do
  namespace :v1 do
    resources :travels, only: %i(index show)
    resources :places, only: %i(index)
  end
end

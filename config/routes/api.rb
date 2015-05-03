use_doorkeeper if Rails.env.development?
namespace :api do
  namespace :v1 do
    resources :travels, only: %i(index show)
  end
end

Rails.application.routes.draw do
  api_guard_routes for: "admins", controller: {
    registration: "admins/registration",
    authentication: "admins/authentication",
    passwords: "admins/passwords",
    tokens: "admins/tokens"
  }

  get "admins/profile", to: "admins#profile", defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      resources :categories do
        resources :products
      end
    end
  end
end

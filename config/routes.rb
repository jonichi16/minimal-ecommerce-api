Rails.application.routes.draw do
  api_guard_routes for: "admins"
end

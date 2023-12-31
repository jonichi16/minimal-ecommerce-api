class Admin < ApplicationRecord
  has_secure_password

  api_guard_associations refresh_token: "refresh_tokens"
  has_many :refresh_tokens, dependent: :delete_all
end

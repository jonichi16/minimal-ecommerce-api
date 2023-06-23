class AdminSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :created_at
end

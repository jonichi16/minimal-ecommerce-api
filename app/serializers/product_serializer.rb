class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :category, :price, :quantity
end

class ItemSerializer
  include JSONAPI::Serializer
  
  attributes :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at
end
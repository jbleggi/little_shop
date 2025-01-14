class ItemSerializer
  include JSONAPI::Serializer
  
  attributes :name, :description, :unit_price, :merchant_id, :created_at, :updated_at
end
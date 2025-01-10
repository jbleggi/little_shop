class MerchantSerializer
  include JSONAPI::Serializer 
  attributes :id, :name, :created_at, :updated_at
  # has_many :items #serializer: ItemSerializer
  # has_many :invoices #serializer: InvoiceSerializer
end

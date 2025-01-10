class MerchantSerializer
  include JSONAPI::Serializer 
  attributes :id, :name

  # has_many :items #serializer: ItemSerializer
  # has_many :invoices #serializer: InvoiceSerializer
end

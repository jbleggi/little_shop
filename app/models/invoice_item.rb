class InvoiceItem < ApplicationRecord
  has_many :items
  belongs_to :invoice
end
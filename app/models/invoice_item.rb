class InvoiceItem < ApplicationRecord
  belongs_to :invoice, :item
end
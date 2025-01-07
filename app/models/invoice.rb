class Invoice < ApplicationRecord
  has_many :invoice_items
  belongs_to :customer, :merchant, :transaction
end
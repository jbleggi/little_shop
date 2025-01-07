class Invoice < ApplicationRecord
  has_many :invoice_items, :transactions
  belongs_to :customer, :merchant
end
class Invoice < ApplicationRecord
  belongs_to :customer, :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
end
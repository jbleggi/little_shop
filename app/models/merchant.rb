class Merchant < ApplicationRecord
  has_many :invoices, :items
end
class Merchant < ApplicationRecord
  has_many :invoices, :items, dependent: :destroy
end
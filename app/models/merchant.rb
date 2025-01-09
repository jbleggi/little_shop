class Merchant < ApplicationRecord
  # has_many :invoices, :items
  validates :name, presence: true
end
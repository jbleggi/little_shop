class Merchant < ApplicationRecord
  # has_many :invoices, :items
  validates :name, presence: true
  has_many :invoices, :items, dependent: :destroy

end
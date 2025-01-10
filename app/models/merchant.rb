class Merchant < ApplicationRecord
  # has_many :invoices, :items
  validates :name, presence: true
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

end
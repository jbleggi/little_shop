class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
end
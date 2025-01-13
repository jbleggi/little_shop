class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  
  belongs_to :customer
  belongs_to :merchant

  scope :shipped, -> { where(status: 'shipped') }
  scope :returned, -> { where(status: 'returned') }
  scope :packaged, -> { where(status: 'packaged') }
end
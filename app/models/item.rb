class Item < ApplicationRecord
  belongs_to :invoice_item, :merchant
end
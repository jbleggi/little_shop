FactoryBot.define do
  factory :item do
    name { "Test Item" }
    description { "This is a test item." }
    unit_price { 100.0 }
    merchant
  end
end
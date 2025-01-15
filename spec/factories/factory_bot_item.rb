FactoryBot.define do
  factory :item do
    name { "Test Item" }
    description { "Sample description" }
    unit_price { 10.99 }
    merchant
  end
end
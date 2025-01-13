FactoryBot.define do
    factory :item do
      name { "Test Item #{rand(1000)}" }
      description { "This is a test item." }
      unit_price { 100.0 }
      association :merchant
    end
  end
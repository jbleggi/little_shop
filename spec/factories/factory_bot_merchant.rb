FactoryBot.define do
  factory :merchant do
    name { "Test Merchant #{rand(1000)}" }
  end
end
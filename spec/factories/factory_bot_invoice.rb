FactoryBot.define do
    factory :invoice do
			id { rand(1000) }
			status { ["shipped", "returned", "packaged"].sample }
			created_at { Time.now }
			updated_at { created_at }
      association :customer
      association :merchant
    end
  end
FactoryBot.define do
    factory :customer do
      id { rand(1000) }
      first_name { "Test customer first_name"}
      last_name  { "Test customer last_name" }
			created_at {Time.now}
			updated_at {created_at}
    end
  end
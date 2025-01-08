# bundle exec rspec spec/requests/api/v1/merchants_request_spec.rb
require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    Merchant.create!(name: "Mike's Awesome Store")
    Merchant.create!(name: "Store of Fate")
    Merchant.create!(name: "This is the limit of my creativity")

    get '/api/v1/merchants'

    expect(response).to be_successful
  end
end
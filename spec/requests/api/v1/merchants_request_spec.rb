# bundle exec rspec spec/requests/api/v1/merchants_request_spec.rb

require 'rails_helper'

RSpec.describe "Merchants endpoints", type: :request do
  it "sends a list of merchants" do
    Merchant.create!(name: "Mike's Awesome Store")
    Merchant.create!(name: "Store of Fate")
    Merchant.create!(name: "This is the limit of my creativity")

    get "/api/v1/merchants"
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)
    end
  end
end
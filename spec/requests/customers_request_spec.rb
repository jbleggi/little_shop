# bundle exec rspec spec/requests/customers_request_spec.rb
require 'rails_helper'

RSpec.describe "Customers API", type: :request do
  it "returns a list of customers associated with the merchant" do
    merchant = create(:merchant)
    other_merchant = create(:merchant)

    customer1 = create(:customer)
    customer2 = create(:customer)
    customer3 = create(:customer)
    other_customer = create(:customer)

    invoice1 = create(:invoice, merchant: merchant, customer: customer1)
    invoice2 = create(:invoice, merchant: merchant, customer: customer2)
    invoice3 = create(:invoice, merchant: merchant, customer: customer3)
    invoice4 = create(:invoice, merchant: other_merchant, customer: other_customer)
      
    get "/api/v1/merchants/#{merchant.id}/customers"
 
    expect(response).to be_successful

		json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data]).to be_an(Array)
    expect(json[:data].count).to eq(3)

    json[:data].each do |customer|
      expect(customer).to have_key(:id)
      expect(customer[:id]).to be_a String
      expect(customer).to have_key(:type)
      expect(customer[:type]).to eq("customer")
      expect(customer).to have_key(:attributes)
      expect(customer[:attributes]).to have_key(:first_name)
      expect(customer[:attributes][:first_name]).to be_a String
      expect(customer[:attributes]).to have_key(:last_name)
      expect(customer[:attributes][:last_name]).to be_a String
      expect(customer[:attributes]).not_to have_key(:invoice)
    end
  end

  it "returns an empty array if no customers are associated with the merchant" do
    empty_merchant = create(:merchant)

    get "/api/v1/merchants/#{empty_merchant.id}/customers"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data]).to eq([])
  end

  it "returns a not_found status when merchant does not exist" do
    get "/api/v1/merchants/999999/customers"

    expect(response).to have_http_status(:not_found)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:message]).to eq("Your query could not be completed;")
    expect(json[:errors]).to eq("Merchant not found.")
  end
end
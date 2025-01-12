# bundle exec rspec spec/requests/customers_request_spec.rb
require 'rails_helper'

RSpec.describe "Customers API", type: :request do
  it "returns a list of customers associated with the merchant" do
    # create merchant
    merchant = create(:merchant)
    other_merchant = create(:merchant)
    # create customers
    customer1 = create(:customer)
    customer2 = create(:customer)
    customer3 = create(:customer)
    other_customer = create(:customer)
    # create invoices  
    invoice1 = create(:invoice, merchant: merchant, customer: customer1)
    invoice2 = create(:invoice, merchant: merchant, customer: customer2)
    invoice3 = create(:invoice, merchant: merchant, customer: customer3)
    # create unconnected invoice
    invoice4 = create(invoice, merchant: other_merchant, customer: other_customer)
      
    get "/api/v1/merchants/#{merchant.id}/customers"
 
    expect(response).to be_successful

		json = JSON.parse(response.body, symbolize_names: true)

		expect(json["data"]).to be_an(Array)

    expect(json["data"].count).to eq(3)

    json["data"].each do |customer|
      expect(customer).to have_key(:id)
      expect(customer).to have_key(:type)
      expect(customer[:type]).to eq("customer")
      expect(customer).to have_key(:attributes)
      expect(customer[:attributes]).to have_key(:first_name)
      expect(customer[:attributes]).to have_key(:last_name)
    end

    json["data"].each do |customer|
      expect(customer["attributes"]).not_to have_key("invoice")
    end
  end

  it "returns an empty array if no customers are associated with the merchant" do
    # Create a new merchant with no customers
    empty_merchant = create(:merchant)
    get "/api/v1/merchants/#{empty_merchant.id}/customers"
    # Expect the response status to be 200 OK
    expect(response).to have_http_status(:ok)
    # Parse the JSON response
    json = JSON.parse(response.body)
    # Ensure the data array is empty
    expect(json["data"]).to eq([])
  end

	it "returns not_found when the merchant does not exist" do
		get "/api/v1/merchants/999999/customers"
		expect(response).to have_http_status(:not_found)
		json = JSON.parse(response.body)
		expect(json["error"]).to eq("Merchant not found")
	end
end
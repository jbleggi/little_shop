# bundle exec rspec spec/requests/merchants_request_spec.rb

require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  it "sends a list of merchants" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    
    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes]).to have_key(:updated_at)
    end
  end

  it "can get one merchant by its id" do
    merchant_example = create(:merchant)
    merchant_id = merchant_example.id

    get "/api/v1/merchants/#{merchant_id}"

    merchant_response = JSON.parse(response.body, symbolize_names: true)
    merchant_example = merchant_response[:data][:attributes]
    
    expect(response).to be_successful

    expect(merchant_example).to have_key(:id)
    expect(merchant_example).to have_key(:name)
    expect(merchant_example).to have_key(:created_at)
    expect(merchant_example).to have_key(:updated_at)
    
    expect(merchant_response).to be_a Hash
  end

  it "sorted=age returns merchants sorted by created_at in desc order" do
    merchant1 = create(:merchant, created_at: "2025-01-05")
    merchant2 = create(:merchant, created_at: "2025-01-11")
    merchant3 = create(:merchant, created_at: "2025-01-01")

    get "/api/v1/merchants?sorted=age"

    result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    #Time.parse converts API response string into a Time object to compare
    expect(Time.parse(result[:data][0][:attributes][:created_at])).to eq(merchant2.created_at)
    expect(Time.parse(result[:data][1][:attributes][:created_at])).to eq(merchant1.created_at)
    expect(Time.parse(result[:data][2][:attributes][:created_at])).to eq(merchant3.created_at)
  end

  describe "GET /items/:id/merchant" do
    it "returns the merchant associated with an item" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(result[:data][:attributes][:id]).to eq(merchant.id)
      expect(result[:data][:attributes][:name]).to eq(merchant.name)
    end

    it "returns a 404 if the item is not found" do
      get "/api/v1/items/9999/merchant"  

      expect(response).to have_http_status(404)
      result = JSON.parse(response.body, symbolize_names: true)
      expect(result[:error]).to eq("Item not found")
    end  
  end
  
  describe "POST /api/v1/merchants" do
    it "creates a new merchant and returns the merchant in the response" do
      # Sending a POST request with JSON body, including the `merchant` key
      post '/api/v1/merchants', params: { merchant: { name: "New Merchant" } }.to_json, headers: { 'Content-Type' => 'application/json' }

      # Check for a successful creation (HTTP 201 status)
      expect(response).to have_http_status(:created)

      # Parse the response and check if the name matches the one sent
      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']['name']).to eq('New Merchant')
    end
  end

  describe "DELETE /api/v1/merchants/:id" do
    it "deletes the merchant and associated items and returns no content" do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)

      expect(Merchant.exists?(merchant.id)).to be_falsey
      expect(Item.exists?(item1.id)).to be_falsey
      expect(Item.exists?(item2.id)).to be_falsey
    end
    
    it "returns a 404 Not Found status and an error message" do
      delete "/api/v1/merchants/99999" 

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Merchant not found")
    end

    it "returns an error message if any attribute is missing" do
      post '/api/v1/merchants', params: { merchant: { name: '' } }.to_json, headers: { 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)
      
      expect(json_response['error']).to eq('Unable to create merchant')
      
      expect(json_response['details']).to include("Name can't be blank")
    end
  end

  describe "PATCH /api/v1/merchants/:id" do
    it "updates and returns the merchant" do
      merchant = create(:merchant)
      updated_params = { name: "Updated Merchant Name" }

      patch "/api/v1/merchants/#{merchant.id}", params: { merchant: updated_params }.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']['name']).to eq("Updated Merchant Name")
    end

    it "returns error message if attributes other than name are updated" do
      merchant = create(:merchant)
      invalid_params = { name: "Updated Merchant", address: "123 New Street" }
      patch "/api/v1/merchants/#{merchant.id}", params: { merchant: invalid_params }.to_json, headers: { 'Content-Type' => 'application/json' }

      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)

      expect(json_response['error']).to eq("Only name can be updated")
    end
  end

end
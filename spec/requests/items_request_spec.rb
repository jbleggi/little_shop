# bundle exec rspec spec/requests/items_request_spec.rb

require 'rails_helper'

RSpec.describe "Items API", type: :request do
  it "sends a list of items" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data].count).to eq(3)
    
    data[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an String
      
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer

      expect(item[:attributes]).to have_key(:created_at)
      expect(item[:attributes][:created_at]).to be_a String

      expect(item[:attributes]).to have_key(:updated_at)
      expect(item[:attributes][:updated_at]).to be_a String
    end

  end

  it "retrieves one item based on id" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data][:id]).to eq(item1.id.to_s)
  end

  it "destroys one item based on id" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items"
    expect(response).to be_successful
    
    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:data].count).to eq(3)

    delete "/api/v1/items/#{item1.id}"
    expect(response).to be_successful
    expect(response).to have_http_status(204)

    get "/api/v1/items"
    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:data].count).to eq(2)

    delete "/api/v1/items/#{item1.id}"
    expect(response).to have_http_status(404)
  end

  it "returns all items associated with a specific merchant" do
    merchant = create(:merchant)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)

    other_merchant = create(:merchant)
    create(:item, merchant: other_merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    
    expect(result[:data].count).to eq(2)

    result[:data].each do |item|
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)    
    end
  end

  it "returns all items when no merchant_id is provided" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items"

    result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(result[:data].count).to eq(3)
  end

  describe "GET /api/v1/items/:id" do
    it "fetches single record for item:id" do
    
      item = create(:item)
      
      get "/api/v1/items/#{item.id}"
      
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response[:data]).to include(
        id: item.id.to_s,
        type: 'item',
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id,
          created_at: item.created_at.as_json,
          updated_at: item.updated_at.as_json
        }
      )
    end
  end

  describe 'GET /api/v1/items/find' do
    it 'finds a single item by name' do
      item = create(:item, name: 'Test Item')
  
      get '/api/v1/items/find?name=Test'
  
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body, symbolize_names: true)
  
      returned_item = parsed_response[:data]
      expect(returned_item[:id]).to eq(item.id.to_s)
      expect(returned_item[:attributes][:name]).to eq('Test Item')
    end
  end
end

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
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes][:id]).to be_an Integer
      
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end

  end

  it "retrieves one item based on id" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful
    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data][:attributes][:id]).to eq(item1.id)
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


end

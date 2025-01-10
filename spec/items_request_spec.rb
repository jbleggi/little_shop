require 'rails_helper'

RSpec.describe "Items API", type: :request do
  it "sends a list of items" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    get '/api/v1/items'

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data].count).to eq(3)
    
    data[:data].each do |item|
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end

  end

end

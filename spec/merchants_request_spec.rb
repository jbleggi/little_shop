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
    merchant_example = merchant_response[:merchant][:data][:attributes]
    
    expect(response).to be_successful

    expect(merchant_example).to have_key(:id)
    expect(merchant_example).to have_key(:name)
    expect(merchant_example).to have_key(:created_at)
    expect(merchant_example).to have_key(:updated_at)
    
    expect(merchant_response).to be_a Hash
  end

  it "can return all items associated with a merchant" do
    merchant = create(:merchant)
  
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    
    get "/api/v1/merchants/#{merchant.id}/items"
    
    result = JSON.parse(response.body, symbolize_names: true)
  end

end
# result[:merchant][:data][:id] #merchant's id
# result[:items][:data].length #31
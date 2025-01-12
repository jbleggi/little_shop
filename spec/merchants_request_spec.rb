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

end

require 'rails_helper'
# wrote comments in items for how this works

RSpec.describe MerchantSerializer, type: :serializer do
    describe "serializes" do
        it 'serializes merchants' do
            # Arrange: Create a merchant using FactoryBot
            merchant = create(:merchant)
          
            # Act: Serialize the merchant
            serialize_merchant = MerchantSerializer.new(merchant).to_json

            expect(serialize_merchant[:data]).to include(
                id: merchant.id,
                type: :merchant,
                attributes: {
                    id: merchant.id,
                    name: merchant.name,
                    created_at: merchant.created_at.as_json,
                    updated_at: merchant.updated_at.as_json
                }

                serialized_data = JSON.parse(serialize_merchant, symbolize_names: true)[:data]

          
            # Assert: Verify the serialized JSON structure
            expect(serialized_data).to include(
              id: merchant.id.to_s,  # Expecting the id to be a string
              type: 'merchant',      # Type should be a string
              attributes: {
                id: merchant.id,  # id as an integer in attributes
                name: merchant.name,
                created_at: merchant.created_at.as_json,
                updated_at: merchant.updated_at.as_json,
              }
            )
          end
    end
end

RSpec.describe 'Merchants API', type: :request do
    describe 'POST /api/v1/merchants' do
      context 'with valid parameters' do
        it 'creates a new merchant and returns the merchant in the response' do
          
          merchant_params = { name: 'New Merchant' }
  
          post '/api/v1/merchants', params: merchant_params.to_json, headers: { 'Content-Type': 'application/json' }
   
          expect(json['data']['type']).to eq('merchant')  
          expect(json['data']['attributes']['name']).to eq('New Merchant')  
        end
      end
    end
end
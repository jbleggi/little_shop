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
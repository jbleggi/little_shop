require 'rails_helper'

RSpec.describe MerchantSerializer, type: :serializer do
  describe "serializes" do
    it 'serializes merchants correctly' do
      # Arrange: Create a merchant using FactoryBot
      merchant = create(:merchant)
          
      # Act: Serialize the merchant
      serialized_json = MerchantSerializer.new(merchant).to_json

      # Parse the JSON to a Ruby hash for easier assertion
      serialized_data = JSON.parse(serialized_json, symbolize_names: true)

      # Assert: Verify the serialized JSON structure
      expect(serialized_data).to include(
        data: {
          id: merchant.id.to_s,        # Expecting the id to be a string
          type: 'merchant',             # Type should be a string 'merchant'
          attributes: {
            id: merchant.id,           # id as an integer in attributes
            name: merchant.name,
            created_at: merchant.created_at.as_json,
            updated_at: merchant.updated_at.as_json,
          }
        }
      )
    end
  end
end

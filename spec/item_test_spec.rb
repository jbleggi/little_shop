require 'rails_helper'

RSpec.describe ItemSerializer, type: :serializer do
  describe 'serialization' do
    it 'serializes an item correctly' do
      # Arrange: Create an item using FactoryBot
      item = create(:item)

      # Act: Serialize the item
      serialize_item = ItemSerializer.new(item).to_json
      serialized_data = JSON.parse(serialize_item, symbolize_names: true)[:data]

      # Assert: Verify the serialized JSON structure
      expect(serialized_data).to include(
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
end
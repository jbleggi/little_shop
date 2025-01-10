require 'rails_helper'
# wrote comments in items for how this works

RSpec.describe MerchantSerializer, type: :serializer do
    describe "serializes" do
        it 'serializes merchants' do

            merchant = create(:merchant)
            serialize_merchant = MerchantSerializer.new(merchant).to_json

            expect(serialize_merchant[:data]).to include(
                id: ,
                type: :merchant,
                attributes: {
                    id: merchant.id,
                    name: merchant.name,
                    created_at: merchant.created_at.as_json,          
                    updated_at: merchant.updated_at.as_json,
                }
            )
        end
    end
end
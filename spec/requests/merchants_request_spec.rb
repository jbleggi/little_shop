# bundle exec rspec spec/requests/merchants_request_spec.rb

require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant) }
  let!(:merchant3) { create(:merchant) }

  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes]).to have_key(:updated_at)
      end
    end
    
    describe "POST /api/v1/merchants" do
      it "creates a new merchant" do
        merchant_params = { merchant: { name: "New Merchant" } }
  
        post "/api/v1/merchants", params: merchant_params
  
        expect(response).to have_http_status(:created)
  
        new_merchant = JSON.parse(response.body, symbolize_names: true)
        expect(new_merchant[:data][:attributes][:name]).to eq("New Merchant")
      end
  
      it "returns an error if merchant creation fails" do
        invalid_params = { merchant: { name: nil } }
  
        post "/api/v1/merchants", params: invalid_params
  
        expect(response).to have_http_status(:unprocessable_entity)
  
        error_response = JSON.parse(response.body, symbolize_names: true)
    end
  
    describe "PATCH /api/v1/merchants/:id" do
      it "updates an existing merchant" do
        updated_params = { merchant: { name: "Updated Merchant" } }
  
        patch "/api/v1/merchants/#{merchant1.id}", params: updated_params
  
        expect(response).to be_successful
  
        updated_merchant = JSON.parse(response.body, symbolize_names: true)
        expect(updated_merchant[:data][:attributes][:name]).to eq("Updated Merchant")
      end
  
      it "returns an error if the merchant is not found for update" do
        updated_params = { merchant: { name: "Updated Merchant" } }
  
        patch "/api/v1/merchants/9999", params: updated_params
  
        expect(response).to have_http_status(404)
  
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Merchant not found")
      end
  
      it "returns an error if merchant update fails" do
        invalid_params = { merchant: { name: nil } }
  
        patch "/api/v1/merchants/#{merchant1.id}", params: invalid_params
  
        expect(response).to have_http_status(:unprocessable_entity)
  
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Unable to update merchant")
      end
    end
  
    describe "DELETE /api/v1/merchants/:id" do
      it "deletes an existing merchant" do
        delete "/api/v1/merchants/#{merchant1.id}"
  
        expect(response).to have_http_status(:no_content)
        expect { merchant1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
  
      it "returns a 404 if the merchant to delete is not found" do
        delete "/api/v1/merchants/9999"
  
        expect(response).to have_http_status(404)
  
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Merchant not found")
      end
    end
  
      it "can get one merchant by its id" do
        merchant_example = create(:merchant)
        merchant_id = merchant_example.id

        get "/api/v1/merchants/#{merchant_id}"

        merchant_response = JSON.parse(response.body, symbolize_names: true)
        merchant_example = merchant_response[:data][:attributes]
        
        expect(response).to be_successful
        expect(merchant_response[:data]).to have_key(:id)
        expect(merchant_example).to have_key(:name)
        expect(merchant_example).to have_key(:created_at)
        expect(merchant_example).to have_key(:updated_at)
        expect(merchant_response).to be_a Hash
      end

  
      it "sorted=age returns merchants sorted by created_at in desc order" do
        merchant1.update(created_at: "2025-01-05")
        merchant2.update(created_at: "2025-01-11")
        merchant3.update(created_at: "2025-01-01")

        get "/api/v1/merchants?sorted=age"

        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful

        expect(Time.parse(result[:data][0][:attributes][:created_at])).to eq(merchant2.created_at)
        expect(Time.parse(result[:data][1][:attributes][:created_at])).to eq(merchant1.created_at)
        expect(Time.parse(result[:data][2][:attributes][:created_at])).to eq(merchant3.created_at)
      end
    end
  
    describe "GET /api/v1/items/:id/merchant" do
      it "returns the merchant associated with an item" do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)

        get "/api/v1/items/#{item.id}/merchant"

        result = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(result[:data][:attributes][:id]).to eq(merchant.id)
        expect(result[:data][:attributes][:name]).to eq(merchant.name)
      end

      it "returns a 404 if the item is not found" do
        get "/api/v1/items/9999/merchant"

        expect(response).to have_http_status(404)
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:error]).to eq("Item not found")
      end
    end
  
    describe "GET /api/v1/merchants/:id" do
      it "fetches single record for merchant:id" do
      
        merchant = create(:merchant)
        
        get "/api/v1/merchants/#{merchant.id}"
        
        expect(response).to be_successful
        parsed_response = JSON.parse(response.body, symbolize_names: true)
  
        expect(parsed_response[:data]).to include(
          id: merchant.id.to_s,
          type: 'merchant',
          attributes: {
            id: merchant.id,
            name: merchant.name,
            created_at: merchant.created_at.as_json,
            updated_at: merchant.updated_at.as_json
          }
        )
      end
    end


    describe "POST /api/v1/merchants" do
      it "creates a new merchant" do
        merchant_params = { merchant: { name: "New Merchant" } }

        post "/api/v1/merchants", params: merchant_params

        expect(response).to have_http_status(:created)

        new_merchant = JSON.parse(response.body, symbolize_names: true)
        expect(new_merchant[:data][:attributes][:name]).to eq("New Merchant")
      end

      it "returns an error if merchant creation fails" do
        invalid_params = { merchant: { name: nil } }

        post "/api/v1/merchants", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Unable to create merchant")
      end
    end
 
    describe "PATCH /api/v1/merchants/:id" do
      it "updates an existing merchant" do
        updated_params = { merchant: { name: "Updated Merchant" } }

        patch "/api/v1/merchants/#{merchant1.id}", params: updated_params

        expect(response).to be_successful

        updated_merchant = JSON.parse(response.body, symbolize_names: true)
        expect(updated_merchant[:data][:attributes][:name]).to eq("Updated Merchant")
      end

      it "returns an error if the merchant is not found for update" do
        updated_params = { merchant: { name: "Updated Merchant" } }

        patch "/api/v1/merchants/9999", params: updated_params

        expect(response).to have_http_status(404)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Merchant not found")
      end

      it "returns an error if merchant update fails" do
        invalid_params = { merchant: { name: nil } }

        patch "/api/v1/merchants/#{merchant1.id}", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Unable to update merchant")
      end
    end

    describe "DELETE /api/v1/merchants/:id" do
      it "deletes an existing merchant" do
        delete "/api/v1/merchants/#{merchant1.id}"

        expect(response).to have_http_status(:no_content)
        expect { merchant1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns a 404 if the merchant to delete is not found" do
        delete "/api/v1/merchants/9999"

        expect(response).to have_http_status(404)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Merchant not found")
      end
    end

    describe 'GET /api/v1/merchants/find_all' do
      it 'finds all merchants that match the search term' do
        create(:merchant, name: 'Illinois Trading Co.')
        create(:merchant, name: 'ILL Coffee Roasters')
        create(:merchant, name: 'Unrelated Merchant')
    
        get '/api/v1/merchants/find_all?name=ILL'
    
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        returned_merchants = parsed_response[:data]
        names = returned_merchants.map { |merchant| merchant[:attributes][:name] }
        # binding.pry

        expect(names).to include('Illinois Trading Co.', 'ILL Coffee Roasters')
        expect(names).not_to include('Unrelated Merchant')
        expect(returned_merchants.count).to eq(2)
  
    end
  end
end
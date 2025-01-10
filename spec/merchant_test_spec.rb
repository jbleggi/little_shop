require 'rails_helper'
# wrote comments in items for how this works

RSpec.describe "Merchants Endpoints" do
    describe "/api/v1/merchants" do
        it "returns all merchants with the appropriate info" do 
        get "/api/v1/merchants", headers:{"Content-type": "Application/JSON"}

        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Array)
        expect(data[0]).to be_a(Hash)

        expect(data[0]).to have_key(:id)
        expect(data[0][:id]).to be_a(Integer)


        expect(data[0]).to have_key(:name)
        expect(data[0][:name]).to be_a(String)
        
        end
    end
end
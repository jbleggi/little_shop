# bundle exec rspec spec/requests/api/v1/merchants_request_spec.rb

require 'rails_helper'
require 'simplecov'
SimpleCov.start 'rails'

SimpleCov.add_filter '/app/channels/'
SimpleCov.add_filter '/app/jobs/'
SimpleCov.add_filter '/app/mailers/'

RSpec.describe "Merchants endpoints", type: :request do
  before :all do
    Merchant.create!(name: "Mike's Awesome Store")
    Merchant.create!(name: "Store of Fate")
    Merchant.create!(name: "This is the limit of my creativity")
  end

  after :all do 
    
  end

  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    binding.pry
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "sorts merchants by created_at timestamp, newest first" do
    get '/api/v1/merchants?sorted=age'

    expect(response).to be_successful
    expect(Merchant.maximum("created_at")).to eq(Merchant.order("created_at desc").pluck(:created_at).last)  
  end
  
  it "retrieves merchants by id" do
  get '/api/v1/merchants/:id'

  expect(response).to be_successful
  
  end

end
# bundle exec rspec spec/models/customer_spec.rb
require 'rails_helper'

describe Customer, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
  end
end
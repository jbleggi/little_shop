# bundle exec rspec spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
  end
end
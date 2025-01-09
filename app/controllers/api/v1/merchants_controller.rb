
class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:sorted] === 'age'
      merchants = Merchant.all.order(created_at: :desc)
    else 
      merchants = Merchant.all
    end
    
    render json: MerchantSerializer.new(merchants)
  end

module Api
  module V1
    class MerchantsController < ApplicationController
      def items
        merchant = Merchant.find_by(id: params[:id])
        if merchant
          render json: MerchantSerializer.new(merchant.items).to_json
        else
          render json: { message: "Merchant not found", errors: ["Merchant with id #{params[:id]} does not exist"] }, status: 404
        end
      end
    end
  end
end
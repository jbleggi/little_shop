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
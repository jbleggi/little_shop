class Api::V1::CustomersController < ApplicationController
  def show
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])

      if merchant
        customers = Customer.where(merchant_id: merchant.id)
        render json: customers, status: :ok
      else
        render json: { error: "Merchant not found" }, status: :not_found
      end
    else
      render json: { error: "Merchant ID is required" }, status: :unprocessable_entity
    end
  end
end
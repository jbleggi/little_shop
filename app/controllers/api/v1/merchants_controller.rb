class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all

    merchants = merchants.order(created_at: :desc) if params[:sorted] == 'age'

    merchants = merchants.map do |merchant|
      merchant.attributes.merge(item_count: merchant.items.count)
    end if params[:count] == 'true'

    render json: MerchantSerializer.new(merchants).serializable_hash[:data]
  end

  def show
    merchant = Merchant.find_by(id: params[:id])

    if merchant
      render json: MerchantSerializer.new(merchant).serializable_hash[:data]
    else
      render json: { message: "Merchant not found", errors: ["Merchant with id #{params[:id]} does not exist"] }, status: :not_found
    end
  end
  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      render json: MerchantSerializer.new(merchant).serializable_hash[:data], status: :created
    else
      render json: { message: "Merchant creation failed", errors: merchant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
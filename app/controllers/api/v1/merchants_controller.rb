class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:sorted] === 'age'
      merchants = Merchant.all.order(created_at: :desc)
    else 
      merchants = Merchant.all
    end
    
    render json: MerchantSerializer.new(merchants)
    #(merchants, is_collection: true) ??
  end

  def show
    merchant = Merchant.find(params[:id])
 
    render json: MerchantSerializer.new(merchant)
  end
end 
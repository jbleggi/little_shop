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
    if params[:item_id]
      item = Item.find_by(id: params[:item_id])
      if item.nil?
        render json: { error: "Item not found" }, status: :not_found
      else
        render json: MerchantSerializer.new(item.merchant)
      end
    else
      merchant = Merchant.find_by(id: params[:id])
  
      render json: MerchantSerializer.new(merchant)
    end
  end
end 
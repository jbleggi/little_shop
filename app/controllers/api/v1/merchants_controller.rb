class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:sorted] === 'age'
      merchants = Merchant.all.order(created_at: :desc)
    else 
      merchants = Merchant.all
    end
    
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    items = merchant.items
    
    render json: {
      merchant: MerchantSerializer.new(merchant),
      items: ItemSerializer.new(items)
    }
  end
end
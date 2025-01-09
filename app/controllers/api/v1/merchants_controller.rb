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

  end

end
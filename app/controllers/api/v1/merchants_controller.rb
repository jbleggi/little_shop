class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:sorted] == 'age'
      merchants = Merchant.all.order(created_at: :desc)
    else
      merchants = Merchant.all
    end
    render json: MerchantSerializer.new(merchants)
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

  def create
    # Initialize a new Merchant with the permitted parameters
    merchant = Merchant.new(merchant_params)
  
    if merchant.save
        # Return the newly created merchant using the MerchantSerializer
      render json: MerchantSerializer.new(merchant), status: :created
    else
      # If validation fails, return an error message
      render json: { error: 'Unable to create merchant', details: merchant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    merchant = Merchant.find_by(id: params[:id])

    if merchant
      if merchant.update(merchant_params)
        render json: MerchantSerializer.new(merchant)
      else
        render json: { error: 'Unable to update merchant', details: merchant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Merchant not found' }, status: :not_found
    end
  end

  def destroy
    merchant = Merchant.find_by(id: params[:id])

    if merchant
      merchant.destroy
      head :no_content 
    else
      render json: { error: 'Merchant not found' }, status: :not_found
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
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
      if params[:merchant].keys != ["name"]
        # If any attribute other than 'name' is passed, return an error
        render json: { error: 'Only name can be updated' }, status: :unprocessable_entity
      elsif merchant.update(merchant_params)
        # If update is successful, return the updated merchant
        render json: MerchantSerializer.new(merchant)
      else
        # If validation fails on the name, return errors
        render json: { error: 'Unable to update merchant', details: merchant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # If the merchant does not exist, return a not found error
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

  def find_all
    merchants = Merchant.where('name ILIKE ?', "%#{params[:name]}%")
  
    if merchants.present?
      render json: MerchantSerializer.new(merchants), status: :ok
    else
      render json: { data: [] }, status: :ok
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
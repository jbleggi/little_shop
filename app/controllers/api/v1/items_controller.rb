class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])
      return render json: { error: 'Merchant not found' }, status: 404 unless merchant
  
      items = merchant.items
    else
      items = Item.all
    end
    render json: ItemSerializer.new(items)
  end
      
  def destroy
    item = Item.find_by(id: params[:id])
    
    if item
        item.destroy
    else
        render json: { message: "Item not found", errors: ["Item with id #{params[:id]} does not exist"] }, status: 404
    end
  end

  def show 
    item = Item.find_by(id: params[:id])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { error: 'Item not found' }, status: 404
    end
  end
end
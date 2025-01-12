class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]  
      merchant = Merchant.find(params[:merchant_id]) 
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

    render json: ItemSerializer.new(item)
  end
end

#items = Item.where(merchant_id: ${:id})
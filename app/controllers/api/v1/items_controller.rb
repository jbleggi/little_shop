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

  def show 
    item = Item.find_by(id: params[:id])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { error: 'Item not found' }, status: 404
    end
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: 'Unable to create item', details: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find_by(id: params[:id])

    if item
      if item.update(item_params)
        render json: ItemSerializer.new(item)
      else
        render json: { error: 'Unable to update item', details: item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Item not found' }, status: :not_found
    end
  end

  def destroy
    item = Item.find_by(id: params[:id])
    
    if item
      item.destroy
      head :no_content 
    else
      render json: { error: 'Item not found' }, status: :not_found

    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
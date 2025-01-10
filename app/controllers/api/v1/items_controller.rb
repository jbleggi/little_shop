module Api
  module V1
    class ItemsController < ApplicationController
      def destroy
        item = Item.find_by(id: params[:id])
        
        if item
          item.destroy
          head :no_content  
        else
          render json: { message: "Item not found", errors: ["Item with id #{params[:id]} does not exist"] }, status: :not_found
        end
      end

      def create
        item = Item.new(item_params)
        if item.save
          render json: ItemSerializer.new(item).serializable_hash[:data], status: :created
        else
          render json: { message: "Item creation failed", errors: item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = Item.all

        render json: ItemSerializer.new(items)
      end
      
      def destroy
        item = Item.find_by(id: params[:id])
        if item
          item.destroy
          head :no_content  
        else
          render json: { message: "Item not found", errors: ["Item with id #{params[:id]} does not exist"] }, status: 404
        end
      end
    end
  end
end
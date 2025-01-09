require 'rails_helper'

class Api::V1::MerchantsController < ApplicationController
    def index 
        #needed for fetching all merchants
        merchants = Merchant.all
        render json: merchants, status: :ok 
        #rendering jason and setting default status to ok
    end

    # def create
    #     merchant = Merchant.create()
    #     if render json: merchant, status: :ok
    #         render json: merchant.errors, status: 418
    #     end
    #   rescue ActiveRecord::RecordNotFound
    #     render json: { error: "Merchant not created" }, status: :not_found
    # end
end

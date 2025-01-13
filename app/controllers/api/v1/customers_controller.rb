class Api::V1::CustomersController < ApplicationController
  def show
    # merchant object by given id
    merchant = Merchant.find_by(id: params[:merchant_id])
    # list invoices for merchant
    invoices = Invoice.where(merchant_id: params[:merchant_id])
    # pluck all customer ids from invoices
    invoices_customers = invoices.pluck(:customer_id)
    # find all customers from invoices_customers 
    customers = Customer.where(id: invoices_customers)
    # find given invoice status for a merchant_id
    # invoices_status = invoices.where(status: params[:status])

    if merchant.nil?
      render json: {
        message: "Your query could not be completed;",
        errors: "Merchant not found."  
          }, 
      status: :not_found
      
      else
        render json: CustomerSerializer.new(customers)
    end
  end
end
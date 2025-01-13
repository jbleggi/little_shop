class Api::V1::InvoicesController < ApplicationController
  def index
    begin
      merchant = Merchant.find(params[:merchant_id])

      invoices = Invoice.where(merchant_id: params[:merchant_id])
      invoices = invoices.where(status: params[:status]) if params[:status]

      render json: InvoiceSerializer.new(invoices)

    rescue ActiveRecord::RecordNotFound
      render json: { message: "Your query could not be completed.", errors: "Merchant with this ID does not exist" }, status: :not_found
    end
  end
end

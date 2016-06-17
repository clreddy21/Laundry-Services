class Admin::CustomersController < ApplicationController
  before_action :authenticate_user!

  def list_of_customers
    @customers = Customer.all
  end


  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :mobile, :avatar)
  end
end

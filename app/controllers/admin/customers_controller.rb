class Admin::CustomersController < ApplicationController
  before_action :authenticate_user!

  def list_of_customers
    @customers = Customer.includes(:orders, :wallet).all
  end

  def new
    @customer = Customer.new
  end

  def show
    @customer = Customer.includes(:orders).find(params[:id])
    @amount = @customer.orders.pluck(:total_cost).sum
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def create
    customer = Customer.create(customer_params)
    if customer.save!
      redirect_to list_of_admin_customers_path, notice: 'Customer added successfully.'
    else
      redirect_to new_admin_customer_path, notice: 'Failed to add Customer, please try again.'
    end
  end

  def update
    customer = Customer.find(params[:id])
    customer.update(customer_params)
    if customer.save!
      redirect_to admin_customer_path(customer), notice: 'Customer updated successfully.'
    else
      redirect_to :back, notice: 'Failed to update Customer, please try again.'
    end
  end

  def add_funds_to_wallet
    customer = Customer.find(params[:id])
    amount = params[:wallet][:amount].to_f
    customer.add_funds(amount)

    redirect_to :back, notice: 'Funds added to customer successfully.'
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :mobile, :avatar)
  end
end

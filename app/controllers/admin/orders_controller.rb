class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!


  def index
    @orders = Order.includes(:service_provider, :customer, :logistic).all
  end

  def show
    @order = Order.includes(:order_items, :order_comments, :service_provider, :customer, :logistic, :payment).find(params[:id])
    @service_providers = @order.service_provider.nil?? ServiceProvider.all : nil
    @logistics = @order.logistic.nil?? Logistic.all : nil
  end

  def list_of_orders_without_logistic
    @orders = Order.without_logistic
    @logistics = Logistic.all
  end

  def list_of_orders_without_service_provider
    @orders = Order.without_service_provider
    @service_providers = ServiceProvider.all
  end

  def assign_service_provider_to_order
    order = Order.find(params[:order_id])
    order.update(service_provider_id: params[:service_provider_id])
    redirect_to :back, notice: 'Successfully assigned service provider to the order.'
  end

  def assign_logistic_to_order
    order = Order.find(params[:order_id])
    order.update(logistic_id: params[:logistic_id])
    redirect_to :back, notice: 'Successfully assigned logistic to the order.'
  end

end
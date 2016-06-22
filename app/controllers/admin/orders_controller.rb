class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!

  def list_of_orders_without_logistic
    @orders = Order.without_logistic
    @logistics = Logistic.all
  end

  def list_of_orders_without_service_provider
    @orders = Order.without_service_provider
    @service_providers = ServiceProvider.all
  end

  def assign_service_provider_to_order
  	raise params
  end

  def assign_logistic_to_order
  	raise params
  end

end
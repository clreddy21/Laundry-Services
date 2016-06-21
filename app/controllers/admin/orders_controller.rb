class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!

  def list_of_orders_without_logistic
    Order.without_logistic
  end

  def list_of_orders_without_service_provider
    Order.without_service_provider
  end
end
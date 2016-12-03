class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!


  def index
    status_id = params[:status_id]
    @orders = Order.includes(:service_provider, :customer, :logistic, :payment).all.filter_by_status(status_id).by_id
    @orders_without_sp_count = Order.without_service_provider.count
    @orders_without_logistic_count = Order.without_logistic.count
    @orders_count = Order.count
    @statuses = get_statuses
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

    message = 'Successfully assigned service provider to the order.'
    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => order.status_id,
                      'orderId' => order.id, 'isFromNotification' => false}}

    send_mobile_notifications(order, options)
    redirect_to :back, notice: message
  end

  def assign_logistic_to_order
    order = Order.find(params[:order_id])
    order.update(logistic_id: params[:logistic_id])

    message = 'Successfully assigned logistic to the order.'
    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => order.status_id,
                      'orderId' => order.id, 'isFromNotification' => false}}

    send_mobile_notifications(order, options)

    redirect_to :back, notice: message
  end

  protected

  def send_mobile_notifications(order, options)
    order.customer.send_mobile_notification(options) if order.customer
    order.service_provider.send_mobile_notification(options) if order.service_provider
    order.logistic.send_mobile_notification(options) if order.logistic
  end

  def get_statuses
    s = [[0, "All (#{Order.count})"]]
    Status.all.each do |status|
      s << [status.id, "#{status.name.capitalize} (#{status.orders.count})"]
    end
    s
  end



end
module Logistics
  class Orders < Grape::API
    resource :assign_logistic do
      desc "Assign a logistic to order"
      params do
        requires :order_id, type:Integer
        requires :logistic_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(logistic_id: params[:logistic_id])
        {:message => 'Assigned logistic to order', :success => true}
      end
    end

    resource :pick_for_service do
      desc "Pick the items for service from customer by logistic"
      params do
        requires :order_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: "2")
        {:message => 'Assigned logistic to order', :success => true, :order_status => "2"}
      end
    end

    resource :start_service do
      desc "Deliver order items to service provider by logistic and service started"
      params do
        requires :order_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: "3")
        {:message => 'Started service', :success => true, :order_status => "3"}
      end
    end


    resource :finish_service do
      desc "Service provider completed service and is ready for pickup."
      params do
        requires :order_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: "4")
        {:message => 'Finished service', :success => true, :order_status => "4"}
      end
    end


    resource :pick_for_delivery do
      desc "Logistic picked the order items from service provider."
      params do
        requires :order_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: "5")
        {:message => 'Picked up for delivery.', :success => true, :order_status => "5"}
      end
    end


    resource :completed_order do
      desc "Deliver order items to customer by logistic and order completed."
      params do
        requires :order_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: "6")
        {:message => 'Completed Order', :success => true, :order_status => "6"}
      end
    end

  end
end


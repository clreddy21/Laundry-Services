module Logistics
  class Orders < Grape::API


    resource :list_of_orders_of_logistic do
      desc 'List of orders of logistic'
      params do
        requires :logistic_id, type:Integer
      end

      get do
        orders = Order.includes(:service_provider, :customer).where(logistic_id: params[:logistic_id])
        orders_hash = []

        if !orders.blank?
          orders.each do |order|

            orders_hash << {:order_id => order.id, :customer_id => order.customer_id, :service_provider_id => order.service_provider_id,
                           :customer_name => order.customer.full_name, :service_provider_name => order.service_provider.full_name,
                           :total_cost => order.total_cost.to_i, :customer_mobile => order.customer.mobile,
                           :service_provider_mobile => order.service_provider.mobile, :status_id => order.status_id}
          end
        end
        orders_hash
      end
    end


    resource :service_providers_response do
      desc "Service Provider's response to order request"
      params do
        requires :order_id, type:Integer
        requires :is_accepted, type:Boolean
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        comment = params[:comment].present?? params[:comment] : ''
        comment_by_id = params[:comment_by_id]
        response = params[:is_accepted]

        message = order.update_service_provider_response(comment, comment_by_id, response)
        {:message => message, :success => true, :order_status => order.status_id}
      end
    end


    resource :logistics do
      desc 'List of logistics for assigning order'
      params do
      end

      get do
        logistics = Logistic.all.select(:id, :first_name, :last_name, :mobile)
      end
    end

    resource :assign_logistic do
      desc 'Assign a logistic to order'
      params do
        requires :order_id, type:Integer
        requires :logistic_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        message = order.assign_logistic(params[:logistic_id])
        {:message => message, :success => true, :order_status => order.status_id}
      end
    end

    resource :pick_for_service do
      desc 'Pick the items for service from customer by logistic'
      params do
        requires :order_id, type:Integer
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        comment = params[:comment]
        comment_by_id = params[:comment_by_id]
        message = order.pick_for_service(comment, comment_by_id)
        {:message => message, :success => true, :order_status => order.status_id}
      end
    end

    resource :start_service do
      desc 'Deliver order items to service provider by logistic and service started'
      params do
        requires :order_id, type:Integer
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        comment = params[:comment]
        comment_by_id = params[:comment_by_id]
        message = order.start_service(comment, comment_by_id)

        {:message => message, :success => true, :order_status => order.status_id}
      end
    end


    resource :finish_service do
      desc 'Service provider completed service and is ready for pickup.'
      params do
        requires :order_id, type:Integer
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        sps = order.service_provider_stats
        comment = params[:comment]
        comment_by_id = params[:comment_by_id]
        message = order.finish_service(comment, comment_by_id)

        {:message => message, :success => true, :order_status => order.status_id, orders_count: sps[:orders_count],
        total_cost: sps[:total_cost]}
      end
    end


    resource :pick_for_delivery do
      desc 'Logistic picked the order items from service provider.'
      params do
        requires :order_id, type:Integer
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        comment = params[:comment]
        comment_by_id = params[:comment_by_id]
        message = order.finish_service(comment, comment_by_id)

        {:message => message, :success => true, :order_status => order.status_id}
      end
    end


    resource :completed_order do
      desc 'Deliver order items to customer by logistic and order completed.'
      params do
        requires :order_id, type:Integer
        requires :comment, type:String
        requires :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        comment = params[:comment]
        comment_by_id = params[:comment_by_id]
        message = order.completed_order(comment, comment_by_id)
        
        {:message => message, :success => true, :order_status => order.status_id,
         orders_count: logistic_stats[:orders_count], total_cost: logistic_stats[:total_cost]}
      end
    end

  end
end


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
                           :service_provider_mobile => order.service_provider.mobile, :status_id => order.status}
          end
        end
        orders_hash
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
        order.update(logistic_id: params[:logistic_id])
        {:message => 'Assigned logistic to order', :success => true}
      end
    end

    resource :pick_for_service do
      desc 'Pick the items for service from customer by logistic'
      params do
        requires :order_id, type:Integer
        requires :is_accepted, type:Boolean
        optional :comment, type:String
        optional :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        if params[:comment].present?
          commenter = User.find(params[:comment_by_id])
          order.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: params[:comment])
        end

        if params['is_accepted']
          order.update(status: '2')
          {:message => 'Assigned logistic to order', :success => true, :order_status => '2'}
        else
          order.update(status: '7')
          {:message => 'Rejected by service provider', :success => false, :order_status => '7'}
        end
      end
    end

    resource :start_service do
      desc 'Deliver order items to service provider by logistic and service started'
      params do
        requires :order_id, type:Integer
        optional :comment, type:String
        optional :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: '3')
        if params[:comment].present?
          commenter = User.find(params[:comment_by_id])
          order.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: params[:comment])
        end
        {:message => 'Started service', :success => true, :order_status => '3'}
      end
    end


    resource :finish_service do
      desc 'Service provider completed service and is ready for pickup.'
      params do
        requires :order_id, type:Integer
        optional :comment, type:String
        optional :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: '4')
        sps = order.service_provider_stats
        if params[:comment].present?
          commenter = User.find(params[:comment_by_id])
          order.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: params[:comment])
        end
        {message: 'Finished service', success: true, order_status: '4', orders_count: sps[:orders_count],
        total_cost: sps[:total_cost]}
      end
    end


    resource :pick_for_delivery do
      desc 'Logistic picked the order items from service provider.'
      params do
        requires :order_id, type:Integer
        optional :comment, type:String
        optional :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: '5')
        if params[:comment].present?
          commenter = User.find(params[:comment_by_id])
          order.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: params[:comment])
        end
        {:message => 'Picked up for delivery.', :success => true, :order_status => '5'}
      end
    end


    resource :completed_order do
      desc 'Deliver order items to customer by logistic and order completed.'
      params do
        requires :order_id, type:Integer
        optional :comment, type:String
        optional :comment_by_id, type:Integer
      end

      post do
        order = Order.find(params[:order_id])
        order.update(status: '6')
        if params[:comment].present?
          commenter = User.find(params[:comment_by_id])
          order.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: params[:comment])
        end
        logistic_stats = order.logistic_stats
        {:message => 'Completed Order', :success => true, :order_status => '6',
         orders_count: logistic_stats[:orders_count], total_cost: logistic_stats[:total_cost]}
      end
    end

  end
end


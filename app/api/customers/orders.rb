module Customers
  class Orders < Grape::API
    resource :create_order do
      desc "Create a new order"
      params do
				requires :service_provider_id, type:Integer
        requires :customer_id, type:Integer
        requires :total_cost, type:Float
        requires :status, type:String
        optional :comment, type:String
				requires :items, type: Array
  	  end

      post do
      	order = Order.create(service_provider_id: params[:service_provider_id], customer_id: params[:customer_id], total_cost: 
      		params[:total_cost], status: params[:status], :comment => params[:comment])

      	items = []
      	params[:items].each do |item|
					OrderItem.create(:order_id => order.id,:item_id => item[:item_id],:service_type_id => item[:service_type_id], 
						:quantity => item[:quantity], :amount => item[:amount], :remarks => item[:remarks])
      	end

				{:message => 'Order Created Successfully', :success => true, :order_id => order.id}
      end
    end

    resource :list_of_orders_of_customer do
      desc "List of orders of customers"
      params do
        requires :customer_id, type:Integer
  	  end

      get do
      	orders = Order.includes(:service_provider).where(customer_id: params[:customer_id])
        orders_hash = []

        orders.each do |order|

          orders_hash << {:order_id => order.id, :service_provider_id => order.service_provider_id,
                         :service_provider_name => order.service_provider.full_name, :total_cost => order.total_cost,
              :mobile => order.service_provider.mobile, :comment => order.comment}
        end
        orders_hash
      end
    end

    resource :order_details do
      desc "Order Details"
      params do
        requires :order_id, type:Integer
  	  end

      get do
      	order = Order.includes(:order_items, :order_comments).find(params[:order_id])
      	{:order_items => order.order_items.select(:id, :item_id, :service_type_id, :quantity, :amount, :remarks),
         :order_comments => order.order_comments.select(:id, :body, :comment_by_type, :comment_by)}
      end
    end
  end
end

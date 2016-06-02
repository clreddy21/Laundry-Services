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
      		params[:total_cost], status: params[:status])

      	items = []
      	params[:items].each do |item|
					OrderItem.create(:order_id => order.id,:item_id => item[:item_id],:service_type_id => item[:service_type_id], 
						:quantity => item[:quantity], :amount => item[:amount])
      	end

				{:message => 'Order Created Successfully', :success => true, :order_id => order.id}
      end
    end

    resource :list_of_orders_of_customer do
      desc "List of orders of customers"
      params do
        requires :customer_id, type:Integer
  	  end

      post do
      	order = Order.where(customer_id: params[:customer_id])
      end
    end

    resource :order_details do
      desc "Order Details"
      params do
        requires :order_id, type:Integer
  	  end

      post do
      	order = Order.includes(:order_items, :order_comments).find(params[:order_id])
      	{:order_items => order.order_items, :order_comments => order.order_comments}
      end
    end
  end
end

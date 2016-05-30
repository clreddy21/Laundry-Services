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
					OrderItem.create(:order_id => order.id,:item_id => item[:item_id],:quantity => item[:quantity], :amount => item[:amount])
      	end
      end
    end
  end
end

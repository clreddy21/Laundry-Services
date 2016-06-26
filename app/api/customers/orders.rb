module Customers
  class Orders < Grape::API


    resource :test_gcm do
      desc 'assa'
      params do
        # requires :id, type: String
      end
      get do
        gcm = GCM.new('AIzaSyBrlyVq73okwDs9alAxtoiH5KLwmfgmRqg')

        registration_id = ['etawmaXDXyw:APA91bF4TUPMea2DclG5idp90d79HM0ZCmw4JUhs2Fc4LhxpcgfJLMGvnjLTyC6PmuypWPmRBGBX4L9n4nc0mVSm0QlwKH6ZEHjHB465VwhO-NYEZ-ssgFp_6hGnziMV_svgnzK44q8g']

        options = {data: {score: '123'}, collapse_key: 'updated_score'}
        # raise options.inspect
        response = gcm.send(registration_id, options)
        raise response.inspect

      end
    end
    resource :create_order do
      desc 'Create a new order'
      params do
				requires :service_provider_id, type:Integer
        requires :customer_id, type:Integer
        requires :total_cost, type:Float
        requires :status, type:String
        # requires :comments, type:Array
				requires :items, type: Array
				requires :schedule_date, type: String
				requires :address, type: String
				requires :service_provider_chooser, type: String
				requires :payment_mode, type: String
				requires :payment_status, type: String

  	  end

      post do
      	order = Order.create(service_provider_id: params[:service_provider_id], customer_id: params[:customer_id],
               total_cost: params[:total_cost], status_id: params[:status].to_i, :service_provider_chooser => params[:service_provider_chooser])

      	items = []
        commenter = User.find(params[:customer_id])
      	params[:items].each do |item|
					order_item = OrderItem.create(:order_id => order.id,:item_id => item[:item_id],:service_type_id => item[:service_type_id],
						:quantity => item[:quantity], :amount => item[:amount])
          OrderComment.create(order_id: order.id, body: item[:comment], comment_by_type: commenter.type,
          comment_by: commenter.id, order_item_id: order_item.id)
        end


        Schedule.create(:order_id => order.id, :date => Date.parse(params[:schedule_date]))
                        # :from_time => Time.parse(params[:schedule][0][:from_time]),
                        # :to_time => Time.parse(params[:schedule][0][:to_time]))

        Address.create(address: params[:address], :addressable  => order)
        Payment.create(order_id: order.id, amount: params[:total_cost], mode: params[:payment_mode],
        status: params[:payment_status])

				{:message => 'Order Created Successfully', :success => true, :order_id => order.id}
      end
    end

    resource :list_of_orders_of_customer do
      desc 'List of orders of customers'
      params do
        requires :customer_id, type:Integer
  	  end

      get do
      	orders = Order.includes(:service_provider).where(customer_id: params[:customer_id])
        orders_hash = []
        if !orders.blank?
          orders.each do |order|
            sp = order.service_provider
            logistic = order.logistic

            orders_hash << {:order_id => order.id, :service_provider_id => sp.id, :service_provider_name => sp.full_name,
                           :logistic_id => (logistic.nil? ? '' : logistic.id ), :logistic_name => (logistic.nil? ? '' : logistic.full_name),
                           :total_cost => order.total_cost.to_i,:service_provider_mobile => sp.mobile,
                           :logistic_mobile => (logistic.nil? ? '' : logistic.mobile), :status_id => order.status_id}
          end
        end
        orders_hash
      end
    end

    resource :order_details do
      desc 'Order Details'
      params do
        requires :order_id, type:Integer
  	  end

      get do
      	order = Order.includes(:order_items, :order_comments, :payment, :schedule, :address).find(params[:order_id])
        order_items_comments_hash = []
        order.order_items.includes(:service_type).each do |order_item|
          order_item_hash = []
          order_comments_hash = []

          order_item_hash << {:order_item_id => order_item.id, :item_id => order_item.item_id, :item_type => order_item.item_name,
           :service_type_id => order_item.service_type_id, :service_type_name => order_item.service_type_name, :quantity => order_item.quantity,
           :amount => order_item.amount.to_i}

          order_item.order_comments.each do |comment|
            order_comments_hash << {:order_comment_id => comment.id, :comment_body => comment.body, :comment_by_type => comment.comment_by_type,
              :comment_by_id => comment.comment_by, :comment_by_name => User.find(comment.comment_by).full_name}
          end
          order_items_comments_hash << {order_item_hash: order_item_hash, order_comments_hash: order_comments_hash}
        end
        {:order_items_comments_hash => order_items_comments_hash, :order_schedule => order.schedule_date,
        :order_payment => {:amount => order.payment_amount.to_i, :payment_status => order.payment_status, :mode => order.payment_mode},
        :order_address => order.address_address, customer_mobile: order.customer.mobile, 
        service_provider_mobile: order.service_provider.mobile, service_provider_address: order.service_provider.address.address}
      end
    end
  end
end

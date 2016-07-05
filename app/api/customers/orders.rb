module Customers
  class Orders < Grape::API


    resource :test_gcm do
      desc 'testing gcm'
      params do
        # requires :id, type: String
      end
      post do
        gcm = GCM.new('AIzaSyDl8MnvUMrn2XvaLqnWlXQGBGcwv3Urz3I')

        registration_id = ['edJlZqoorVE:APA91bEfVGWlr61Rn85SqRmJvVpaHJhrTbRWGAOnX3dKMFf9rYCrHEPryB-2GYFTwzN5PrEwpxBXOK-cqa0TMgji2HmvqdhogorwFY8iqpB53t7GCcEI62WlaFplLPkJJzzAB5HPptlD']

        options = {data: {'messageType' => 'list','message' => 'boom','title' => 'Laundry Services','statusId' => '4','orderId' => 59},
                   notification: { "click_action" => "OPEN_ACTIVITY_1"}}

        response = gcm.send(registration_id, options)
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
				requires :pickup_date, type: String
				requires :pickup_time, type: String
				requires :address, type: String
				requires :service_provider_chooser, type: String
				requires :payment_mode, type: String
				requires :payment_status, type: String

  	  end

      post do
        customer = Customer.includes(:wallet).find_by_id(params[:customer_id])
        if params[:payment_mode] == 'wallet' && params[:total_cost] < customer.wallet.amount
          {:message => 'Your wallet has insufficient funds.', :success => false}
        else

          if params[:service_provider_chooser] == 'admin'
            service_provider = ServiceProvider.find_by(email: 'admin_sp@ls.com')
          else
            service_provider = ServiceProvider.find(params[:service_provider_id])
          end
          order = Order.create(service_provider_id: nil, customer_id: customer.id,
                 total_cost: params[:total_cost], status_id: params[:status].to_i,
                 :service_provider_chooser => params[:service_provider_chooser])

          items = []
          commenter = customer
          params[:items].each do |item|
            order_item = OrderItem.create(:order_id => order.id,:item_id => item[:item_id],:service_type_id => item[:service_type_id],
              :quantity => item[:quantity], :amount => item[:amount])
            OrderComment.create(order_id: order.id, body: item[:comment], comment_by_type: commenter.type,
            comment_by: commenter.id, order_item_id: order_item.id)
          end


          Schedule.create(:order_id => order.id, :date => Date.parse(params[:pickup_date]),
                          :from_time => Time.parse(params[:pickup_time]))
                          # :to_time => Time.parse(params[:schedule][0][:to_time]))

          Address.create(address: params[:address], :addressable  => order)
          Payment.create(order_id: order.id, amount: params[:total_cost], mode: params[:payment_mode],
          status: params[:payment_status])
          customer.wallet.amount = customer.wallet.amount - params[:total_cost]
          customer.wallet.save!

          message = 'Order Created Successfully'
          options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => order.status_id,
             'orderId' => order.id}}

          customer.send_mobile_notification(options)
          {:message => message, :success => true, :order_id => order.id, status_id: order.status_id}

        end
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

        if order.payment
          order_payment_amount = order.payment_amount.to_i
          order_payment_status = order.payment_status
          order_payment_mode = order.payment_mode
        else
          order_payment_amount = 0
          order_payment_status = ''
          order_payment_mode = ''
        end

        if order.address
          order_address = order.address_address
        else
          order_address = ''
        end

        if !order.service_provider.nil?
          service_provider_mobile = order.service_provider.mobile
          if order.service_provider.address
            service_provider_address = order.service_provider.address.address
          else
            service_provider_address = ''
          end

        else
          service_provider_mobile = ''
          service_provider_address = ''
        end

        if !order.logistic.nil?
          logistic_mobile = order.logistic.mobile
          if order.logistic.address
            logistic_address = order.logistic.address.address
          else
            logistic_address = ''
          end
        else
          logistic_mobile = ''
          logistic_address = ''
        end
        pickup_date = order.schedule ? order.schedule_date : ''
        pickup_time = order.schedule ? order.schedule_from_time : ''
        {:order_items_comments_hash => order_items_comments_hash, :order_pickup_date => pickup_date,
         :order_pickup_time => pickup_time, :order_schedule => order.schedule_date,
        :order_payment => {:amount => order_payment_amount, :payment_status => order_payment_status, :mode => order_payment_mode},
        :order_address => order_address, customer_mobile: order.customer.mobile,
        service_provider_mobile: service_provider_mobile, service_provider_address: service_provider_address,
        logistic_mobile: logistic_mobile, logistic_address: logistic_address}
      end
    end
  end
end

module Complaints
  class Complaints < Grape::API


    resource :list_of_complaints_of_a_user do
      desc 'list of complaints of a user'
      params do
        requires :user_id, type: Integer
      end
      get do
        user = User.find_by_id(params[:user_id])
        if user.nil?
          {success: false, message: 'Invalid User ID'}
        else
          order_ids = user.orders.pluck(:id)
          complaints = Complaint.where(order_id: order_ids)
          complaints.select(:id, :reference_id, :status, :order_id, :title)
        end
      end
    end


    resource :complaint_details do
      desc 'complaint details'
      params do
        requires :order_id, type: Integer
      end
      get do
        order = Order.find_by_id(params[:order_id])

        if order.nil?
          {success: false, message: 'Invalid Order ID'}
        else
          if order.complaints.present?
            complaint = order.complaints.includes(:messages).last
            complaint_messages = complaint.messages.select(:body, :user_id)
            {id: complaint.id, reference_id: complaint.reference_id, status: complaint.status, order_id: complaint.order_id,
             title: complaint.title, comments: complaint_messages}
          else
            {success: false, message: 'no support yet for this order'}
          end

        end
      end
    end

    resource :add_message_to_complaint do
      desc 'adding messages to a complaint'
      params do
        requires :message, type: String
        requires :user_id, type: Integer
        requires :order_id, type: Integer
      end
      post do
        user = User.find_by_id(params[:user_id])
        order = Order.find_by_id(params[:order_id])


        if user.nil?
          {success: false, message: 'Invalid User ID'}
        elsif order.nil?
          {success: false, message: 'Invalid Order Id'}
        else
          if order.complaints.present?
            complaint = order.complaints.includes(:messages).last
          else
            complaint = order.complaints.create(status: 'pending')
          end

          Message.create(body: params[:message], user_id: user.id, messageable: complaint)
          {success: true, message: 'Message added successfully to complaint.',
           complaint_reference_id: complaint.reference_id, complaint_status: complaint.status}
        end

      end
    end
  end
end
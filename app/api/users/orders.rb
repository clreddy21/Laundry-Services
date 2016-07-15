module Users
  class Orders < Grape::API
    resource :add_comment do
      desc 'Adding a comment to order item'
			params do
			  requires :comment, type:String
			  requires :comment_by_id, type:String
			  requires :order_item_id, type:String
			end
			## This takes care of creating user's jwt
			post do
				puts params.inspect

		    if User.exists?(id: params[:comment_by_id])
		    	user = User.find_by(id: params[:comment_by_id])
		    	comment = params[:comment]
		    	order_item = OrderItem.includes(:order).find_by(id: params[:order_item_id])
		    	
		    	order_item.order_comments.create(order_id: order_item.order.id, body: comment,
		    	 comment_by_type: user.type, comment_by_id: user.id)

		    	{success: true, message: 'Comment added successfully.'}

				else
					{:success => false, :message => 'Invalid user id.'}
			  end
			end
		end
	end
end
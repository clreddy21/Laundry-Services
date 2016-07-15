module Users
  class Orders < Grape::API
    resource :add_comment do
      desc 'Adding a comment to order item'
			params do
			  requires :comment, type:String
			  requires :comment_by_id, type:Integer
			  requires :order_item_id, type:Integer
			end
			## This takes care of creating user's jwt
			post do
				puts params.inspect

		    if User.exists?(id: params[:comment_by_id])
		    	user = User.find_by(id: params[:comment_by_id])
		    	comment = params[:comment]
		    	order_item = OrderItem.includes(:order).find_by(id: params[:order_item_id])
		    	
		    	order_item.order_comments.create(order_id: order_item.order_id, body: comment,
		    	 comment_by_type: user.type, comment_by_id: user.id)

		    	{success: true, message: 'Comment added successfully.'}

				else
					{:success => false, :message => 'Invalid user id.'}
			  end
			end
		end

    resource :get_comments_of_order_item do
      desc 'Getting comments of an order item'
			params do
			  requires :order_item_id, type:Integer
			end
			## This takes care of creating user's jwt
			get do
				puts params.inspect

		    if OrderItem.exists?(id: params[:order_item_id])
		    	order_item = OrderItem.includes(:order_comments).find_by(id: params[:order_item_id])

		    	order_comments = []
		    	order_item.order_comments.each do |comment|
		    		order_comments << {id: comment.id, body: comment.body, comment_by_id: comment.comment_by_id,
		    		 comment_by_type: comment.comment_by_type, created_at: comment.created_at}
		    	end
		    	
		    	{success: true, order_comments: order_comments}

				else
					{:success => false, :message => 'Invalid order item id.'}
			  end
			end
		end



	end
end
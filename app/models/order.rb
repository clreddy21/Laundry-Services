class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :service_provider
  belongs_to :logistic
  has_many :order_items
  has_many :order_comments
  has_one :payment
  has_one :schedule
  has_one :address, as: :addressable
  delegate :address, to: :address, prefix: true
  delegate :amount, :status, :mode, to: :payment, prefix: true
  delegate :date, to: :schedule, prefix: true

  def self.without_logistic
    self.where(logistic_id: nil).where.not(status_id: 7)
  end

  def self.without_service_provider
    self.where(service_provider_id: nil, status: 1, service_provider_chooser: 'admin')
  end

  def service_provider_stats
    service_provider = self.service_provider

    orders_count = service_provider.orders.size
    total_cost = service_provider.orders.pluck(:total_cost).sum
    {orders_count: orders_count, total_cost: total_cost}
  end

  def logistic_stats
    logistic = self.logistic

    orders_count = logistic.orders.size
    total_cost = logistic.orders.pluck(:total_cost).sum
    {orders_count: orders_count, total_cost: total_cost}
  end

  def update_service_provider_response(comments, comment_by_id, response)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
	  end

	  if self.status_id == 1
	  	if response
	  		self.update(status_id: 8)
	  		message = 'Service Provider accepted order'
	  	else
	  		self.update(status_id: 7)
			  message = 'Service Provider declined order'
			end
			customer.send_mobile_notification(message)
  	else
  		message = "Service provider cannot accept order now as status is #{Status.find(self.status_id).name}"
  	end
  end

  def assign_logistic(logistic_id)
	  if self.status_id == 1
  		self.update(logistic_id: logistic_id)
		  message = 'Assigned logistic to order'
			customer.send_mobile_notification(message)
  	else
  		message = "Logistic cannot be assigned to this order now as status is #{Status.find(self.status_id).name}"
  	end
  end


  def pick_for_service(comments, comment_by_id)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
		end

	  if self.status_id == 1
  		self.update(status_id: 2)
  		message = 'Logistic picked order items from customer.'
			customer.send_mobile_notification(message)
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def start_service(comments, comment_by_id)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
		end

	  if self.status_id == 2
  		self.update(status_id: 3)
  		message = 'Logistic delivered order items to service provider and service started.'
			customer.send_mobile_notification(message)
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def finish_service(comments, comment_by_id)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
		end

	  if self.status_id == 3
  		self.update(status_id: 4)
  		message = 'Service is completed by service provider and ready for pickup by logistic.'
			customer.send_mobile_notification(message)
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def pick_for_delivery(comments, comment_by_id)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
		end
	  if self.status_id == 4
  		self.update(status_id: 5)
  		message = 'Logistic picked up the order items from service provider and is ready to deliver to customer.'
			customer.send_mobile_notification(message)
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def completed_order(comments, comment_by_id)
		commenter = User.find(comment_by_id)

		if !comments.blank?
			add_comments(comments, commenter)
		end

	  if self.status_id == 5
  		self.update(status_id: 6)
  		message = 'Logistic delivered the order items to customer.'
			customer.send_mobile_notification(message)
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
	end

	protected
	#
	# def send_mobile_notifications
	# end
	
	def add_comments(comments, commenter)
		comments.each do |comment|
			self.order_comments.create(comment_by: commenter.id, comment_by_type: commenter.type, body: comment[:body],
																 order_item_id: comment[:order_item_id])
		end
	end

end

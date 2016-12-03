class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :service_provider
  belongs_to :logistic
  has_many :order_items
  has_many :order_comments
  has_one :payment
  has_one :schedule
  has_one :address, as: :addressable
	has_many :complaints
	has_many :reviews
	has_many :status_dates

	delegate :address, to: :address, prefix: true
  delegate :amount, :status, :mode, to: :payment, prefix: true
  delegate :date, to: :schedule, prefix: true
  delegate :from_time, to: :schedule, prefix: true
  delegate :mode, to: :payment, prefix: true

	after_create :add_reference_id
	scope :by_id, -> { order('id DESC')}
	scope :pending, -> { where(status_id == 6)}
	# scope :is_active, -> { where(:is_active => true) }




	def self.without_logistic
    self.where(logistic_id: nil).where.not(status_id: 7)
  end

  def self.without_service_provider
    o = self.where(service_provider_id: nil)

		# raise o
  end

  def service_provider_stats
    service_provider = self.service_provider
		service_provider.service_provider_stats
  end

  def logistic_stats
    logistic = self.logistic
		logistic.logistic_stats
  end

  def update_service_provider_response(comment, user_id, response)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
	  end

	  if self.status_id == 1
	  	if response
	  		self.update(status_id: 8)
				self.create_status_date(8)
	  		message = 'Service Provider accepted order'
	  	else
	  		self.update(status_id: 7)
				self.create_status_date(7)
				message = 'Service Provider declined order'
			end
	    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
	    'orderId' => self.id, 'isFromNotification' => false}}

			send_mobile_notifications(options)
			message
  	else
  		message = "Service provider cannot accept order now as status is #{Status.find(self.status_id).name}"
  	end
  end

  def assign_logistic(logistic_id)
	  if self.status_id == 1
  		self.update(logistic_id: logistic_id)
		  message = 'Assigned logistic to order'

      options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
    'orderId' => self.id, 'isFromNotification' => false}}

			send_mobile_notifications(options)
			message
  	else
  		message = "Logistic cannot be assigned to this order now as status is #{Status.find(self.status_id).name}"
  	end
  end


  def pick_for_service(comment, user_id)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
		end

	  if self.status_id == 8
  		self.update(status_id: 2)
			self.create_status_date(2)
			message = 'Logistic picked order items from customer.'
	    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id, 'orderId' => self.id, 'isFromNotification' => false}}

			send_mobile_notifications(options)
			message
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def start_service(comment, user_id)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
		end

	  if self.status_id == 2
  		self.update(status_id: 3)
			self.create_status_date(3)
			message = 'Logistic delivered order items to service provider and service started.'
	    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
    'orderId' => self.id, 'isFromNotification' => false}}

			send_mobile_notifications(options)
			message
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def finish_service(comment, user_id)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
		end

	  if self.status_id == 3
			self.update(status_id: 4)
			self.create_status_date(4)
			message = 'Service is completed by service provider and ready for pickup by logistic.'
			    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
    'orderId' => self.id, 'isFromNotification' => false}}
			self.service_provider.wallet.increment!(:amount, by = self.total_cost)

			send_mobile_notifications(options)
			message
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def pick_for_delivery(comment, user_id)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
		end

	  if self.status_id == 4
  		self.update(status_id: 5)
			self.create_status_date(5)
			message = 'Logistic picked up the order items from service provider and is ready to deliver to customer.'
	    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
    'orderId' => self.id, 'isFromNotification' => false}}

			send_mobile_notifications(options)
			message
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
  end

  def completed_order(comment, user_id)

		if !comment.nil?
			commenter = User.find(user_id)
			add_comment(comment, commenter)
		end

		if self.status_id == 5
  		self.update(status_id: 6)
			self.create_status_date(6)
			message = 'Logistic delivered the order items to customer.'
	    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services', 'statusId' => self.status_id,
    'orderId' => self.id, 'isFromNotification' => true, serviceProviderId: self.service_provider.id, statusId: self.status_id}}
			self.logistic.wallet.increment!(:amount, by = self.total_cost)

			send_mobile_notifications(options)
			message
  	else
  		message = "This request is invalid as order's status is #{Status.find(self.status_id).name}"
  	end
	end

	def self.filter_by_status(status_id)
		if status_id == '0' || status_id.nil?
			self.all
		else
			self.where(status_id: status_id.to_i)
		end
	end


	def create_status_date(status_id)
		self.status_dates.create(status_id: status_id, status_name: Status.find(status_id).name, date: Date.today)
	end



	protected

	def send_mobile_notifications(options)
		self.customer.send_mobile_notification(options)
		self.service_provider.send_mobile_notification(options) if self.service_provider
		self.logistic.send_mobile_notification(options) if self.logistic
	end
	
	def add_comment(comment, commenter)
		self.order_comments.create(comment_by_id: commenter.id, comment_by_type: commenter.type, body: comment)
	end


	def add_reference_id
		reference_id = self.id + 1000000000
		self.update(reference_id: reference_id)
	end

# testing commit
end

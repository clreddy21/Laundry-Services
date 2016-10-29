class WelcomeController < ApplicationController
  before_action :authenticate_user!

	def index
		@total_amount = Payment.by_id.collect(&:amount).sum
		@total_orders = Order.count
		@total_customers = Customer.count
		@total_service_providers = ServiceProvider.count
		@total_logistics = Logistic.count
	end
end

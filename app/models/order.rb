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

  scope :without_logistic, -> { where logistic_id: nil}
  scope :without_service_provider, -> { where (service_provider_id: nil)}


  def without_logistic
    self.where(logistic_id: nil).where.not(status: '7')
  end

  def without_service_provider
    self.where(service_provider_id: nil, status: '1', service_provider_chooser: 'admin')
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

end

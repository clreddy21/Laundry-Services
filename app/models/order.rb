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

end

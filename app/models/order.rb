class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :service_provider
  has_many :order_items
  has_many :order_comments
  has_one :payment
  has_one :schedule
  has_one :address, as: :addressable

end

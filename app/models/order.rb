class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :service_provider
  has_many :order_items
  has_many :order_comments
  has_one :schedule
end

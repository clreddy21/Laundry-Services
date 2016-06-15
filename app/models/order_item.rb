class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  belongs_to :service_type
  has_many :order_comments
end

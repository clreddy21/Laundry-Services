class Customer < User
  has_many :orders
  has_many :order_comments
end
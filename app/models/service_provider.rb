class ServiceProvider < User
  has_many :item_prices
  has_many :orders
  has_many :orders_comments
  has_many :reviews, as: :reviewable
end
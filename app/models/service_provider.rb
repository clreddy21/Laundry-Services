class ServiceProvider < User
  has_many :item_prices
  has_many :reviews, as: :reviewable
end
class ServiceProvider < User
  has_many :item_prices
  has_many :orders
  has_many :orders_comments
  has_many :reviews, as: :reviewable
  # after_save :build_item_prices

  def service_provider_stats
    orders_count = self.orders.size
    total_cost = self.orders.pluck(:total_cost).sum
    {orders_count: orders_count, total_cost: total_cost}
  end
  #
  # def build_item_prices
  #   raise self.id
  # end


end
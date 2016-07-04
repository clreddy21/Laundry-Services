class Logistic < User
  has_many :orders

  def logistic_stats
    orders_count = self.orders.size
    total_cost = self.orders.pluck(:total_cost).sum
    {orders_count: orders_count, total_cost: total_cost}
  end
end
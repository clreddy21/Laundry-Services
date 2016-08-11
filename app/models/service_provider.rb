class ServiceProvider < User
  has_many :item_prices
  has_many :orders
  has_many :orders_comments
  has_many :reviews, as: :reviewable
  # after_save :build_item_prices

  def service_provider_stats
    orders_count = self.orders.size
    total_cost = self.orders.pluck(:total_cost).sum
    current_wallet_amount = self.wallet.amount
    {orders_count: orders_count, total_cost: total_cost, current_wallet_amount: current_wallet_amount}
  end

  def build_item_prices
    Item.all.each do |item|
      ServiceType.all.each do |type|
        ItemPrice.create(service_provider_id: self.id, item_id: item.id, service_type_id: type.id, price: 0)
      end
    end
  end


end
class ServiceType < ActiveRecord::Base
  has_many :item_prices
  has_many :order_items
  scope :by_id, -> { order('id DESC')}

end

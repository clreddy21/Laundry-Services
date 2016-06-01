class ServiceType < ActiveRecord::Base
  has_many :item_prices
end

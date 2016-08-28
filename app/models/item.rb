class Item < ActiveRecord::Base
  has_many :item_prices
  has_many :orders

  mount_uploader :avatar, AvatarUploader
end

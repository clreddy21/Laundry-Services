class Item < ActiveRecord::Base
  has_many :item_prices
  has_many :orders
  scope :by_id, -> { order('id DESC')}


  mount_uploader :avatar, AvatarUploader
end

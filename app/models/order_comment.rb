class OrderComment < ActiveRecord::Base
  belongs_to :order
  belongs_to :order_item
  scope :by_id, -> { order('id DESC')}

end

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  belongs_to :service_type
  has_many :order_comments
  delegate :name, to: :service_type, prefix: true
  delegate :name, to: :order, prefix: true
  delegate :name, to: :item, prefix: true

  scope :active, -> { where(:is_active => true) }
  scope :by_id, -> { order('id DESC')}

end

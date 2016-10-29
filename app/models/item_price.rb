class ItemPrice < ActiveRecord::Base
  belongs_to :service_provider
  belongs_to :item
  belongs_to :service_type
  scope :by_id, -> { order('id DESC')}

end

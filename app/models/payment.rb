class Payment < ActiveRecord::Base
  belongs_to :order
  scope :by_id, -> { order('id DESC')}

end

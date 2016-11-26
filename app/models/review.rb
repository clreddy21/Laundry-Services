class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  belongs_to :order
  scope :by_id, -> { order('id DESC')}

end

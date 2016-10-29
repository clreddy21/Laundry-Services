class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  scope :by_id, -> { order('id DESC')}

end

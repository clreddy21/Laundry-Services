class Transaction < ActiveRecord::Base
  belongs_to :user
  scope :by_id, -> { order('id DESC')}

end

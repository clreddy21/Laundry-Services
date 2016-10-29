class Message < ActiveRecord::Base
  belongs_to :messageable, polymorphic: true
  belongs_to :user
  scope :by_id, -> { order('id DESC')}

end

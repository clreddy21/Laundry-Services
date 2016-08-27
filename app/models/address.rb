class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  scope :is_active, -> { where(:is_active => true) }
end

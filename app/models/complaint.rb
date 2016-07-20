class Complaint < ActiveRecord::Base
  belongs_to :order
  has_many :messages, as: :messageable

  # before_save :create_reference_id

  def create_reference_id
    # raise self.id.inspect
    ref_id = self.id + 1000000000
    self.update(reference_id: ref_id)
  end
end

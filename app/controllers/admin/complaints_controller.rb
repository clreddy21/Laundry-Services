class Admin::ComplaintsController < ApplicationController
  before_action :authenticate_user!

  def list_of_complaints
    @complaints = Complaint.all.includes(:order, :messages)
  end

end

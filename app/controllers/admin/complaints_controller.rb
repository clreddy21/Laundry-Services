class Admin::ComplaintsController < ApplicationController
  before_action :authenticate_user!

  def list_of_complaints
    @complaints = Complaint.all.includes(:order, :messages)
  end

  def show
    @complaint = Complaint.find_by(id: params[:id])
    redirect_to list_of_admin_complaints_path if @complaint.nil?
  end
end

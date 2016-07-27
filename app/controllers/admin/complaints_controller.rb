class Admin::ComplaintsController < ApplicationController
  before_action :authenticate_user!

  def list_of_complaints
    @complaints = Complaint.all.includes(:order, :messages)
  end

  def show
    @complaint = Complaint.find_by(id: params[:id])
    redirect_to list_of_admin_complaints_path if @complaint.nil?
  end

  def add_message
    # raise params.inspect
    complaint = Complaint.find_by(id: params[:complaint_id])
    message = Message.create(body: params[:body], user_id: params[:sender_id], messageable: complaint)

    render partial: 'message', locals: {message: message}

  end
end

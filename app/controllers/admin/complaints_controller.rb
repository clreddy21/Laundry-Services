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

  def approve_complaint_and_add_funds

    complaint = Complaint.find(params[:id])
    amount = params[:amount].to_f
    complaint.order.customer.add_funds(amount)
    complaint.update(status: 'approved')
    redirect_to :back, notice: 'Complaint approved.'
  end

  def reject_complaint
    complaint = Complaint.find(params[:id])
    complaint.update(status: 'rejected')
    redirect_to :back, notice: 'Complaint rejected.'
  end
end

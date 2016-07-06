class Notification < ActiveRecord::Base
  belongs_to :user
  scope :is_read, -> { where(:is_read => true) }
  scope :not_read, -> { where(:is_read => false) }
  paginates_per 6

  def self.send_notification(subject, message, order)

  path = Rails.application.routes.url_helpers.admin_order_path(order)

    message = "A new order has been created. You can see the details <a href=#{path}>here</a>."
    Admin.first.notifications.create(:subject => subject, :body => message, :is_read => false)
  end
end

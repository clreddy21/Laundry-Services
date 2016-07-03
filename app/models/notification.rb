class Notification < ActiveRecord::Base
  belongs_to :user

  def self.send_notification(user, subject, message)
    user.notifications.create(:subject => subject, :body => message, :is_read => false)
  end
end

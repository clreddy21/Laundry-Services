class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :send_otp_to_user

  # private

  def send_otp_to_user
    body = 'Hi #{self.first_name}, #{self.otp} is your otp for verification. Please do not disclose it to anyone.'
    HTTParty.get('http://bhashsms.com/api/sendmsg.php?user=ravipenmetsa&pass=mogallu&sender=SETTAB&phone=8686638646&text=#{body}&priority=ndnd&stype=normal')
  end
end


require 'net/http'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address, as: :addressable

  after_create :send_otp_to_user


  reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address

  has_many :items
  has_many :item_prices


  def full_name
    self.first_name + ' ' + self.last_name
  end
  private

  def send_otp_to_user

    body = 'Hi #{self.first_name}, #{self.otp} is your otp for verification. Please do not disclose it to anyone.'
    user = 'ravipenmetsa'
    pass = 'mogallu'
    sender = 'SETTAB'
    phone = self.mobile

    Curl.get('http://bhashsms.com/api/sendmsg.php',
      {
        user: user,
        pass: pass,
        sender: sender,
        phone: phone,
        text: body,
        priority: 'ndnd',
        stype: 'normal'
      }
            )
  end
end

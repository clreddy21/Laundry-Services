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


  def send_mobile_notification(options)
    registration_id = [self.gcm_id]

    gcm = get_gcm
    response = gcm.send(registration_id, options)
  end

  def send_forgot_password_otp
    body = "Hi , #{self.otp} is your otp for forgot password. Please do not disclose it to anyone."
    send_message(body)
  end

  def send_otp_to_user
    body = "Hi #{self.first_name}, #{self.otp} is your otp for verification. Please do not disclose it to anyone."
    send_message(body)
  end

  private

  def send_message(body)

    # body = "Hi #{self.first_name}, #{self.otp} is your otp for verification. Please do not disclose it to anyone."
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

  def get_gcm
    if self.type == 'Customer'
      gcm = GCM.new('AIzaSyDl8MnvUMrn2XvaLqnWlXQGBGcwv3Urz3I')
    elsif self.type == 'ServiceProvider'
      gcm = GCM.new('AIzaSyBBZw8GkFC7yQyD4NV28dwP4E_AbYSKh80')
    elsif self.type == 'Logistic'
      gcm = GCM.new('AIzaSyB8s6F8MH27AFDBOLK99-3zo8Ed3I8FTc8')
    end
  end
end

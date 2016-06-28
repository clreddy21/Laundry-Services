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

  def send_mobile_notification(message)
    customer_gcm = GCM.new('AIzaSyDl8MnvUMrn2XvaLqnWlXQGBGcwv3Urz3I')

    registration_id = ['d4cPN9frd5c:APA91bGYB6PYKh4LXDZNZcy_fKr75O8xXq9mZOdUTU4ECRiRjhfkzHAZB7kUD1QITGZe9G4NkfNcNSiXFiP0tR4GmobVtN3OwBXJMpoV6p4nMTzAgs8FPCLHRl1IGzvSDV4YWcUJLO_n']

    options = {data: {'messageType' => 'list','message' => message,'title' => 'Laundry Services'}}

    response = customer_gcm.send(registration_id, options)
  end

  private

  def send_otp_to_user

    body = "Hi #{self.first_name}, #{self.otp} is your otp for verification. Please do not disclose it to anyone."
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

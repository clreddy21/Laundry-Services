require 'net/http'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  has_many :addresses, as: :addressable
  has_one :wallet
  has_many :refunds
  has_many :notifications
  has_many :transactions
  has_many :messages

  after_create :send_otp_to_user, :create_wallet
  after_create :add_reference_id


  reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address

  has_many :items
  has_many :item_prices
  scope :by_id, -> { order('id DESC')}



  def full_name
    self.first_name + ' ' + self.last_name
  end

  def is_admin?
    self.type == 'Admin'
  end


  def is_customer?
    self.type == 'Customer'
  end


  def is_service_provider?
    self.type == 'ServiceProvider'
  end


  def is_logistic?
    self.type == 'Logistic'
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

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.mobile || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["mobile = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:mobile) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def assign_details
    self.full_name + ' (' + self.mobile + ')' + ' (' + self.orders.pending.count.to_s + ' )'
  end

  def completed_orders
    self.orders.where(:status_id => [6, 7])
  end

  def current_orders
    self.orders.where.not(:status_id => [6, 7])
  end

  def add_funds(amount)
    amount = self.wallet.amount + amount
    self.wallet.update(amount: amount)
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

  def add_reference_id
    reference_id = self.id + 1000000000
    self.update(reference_id: reference_id)
  end

  def create_wallet
    Wallet.create(user_id: self.id, amount: 0.0)
  end
end

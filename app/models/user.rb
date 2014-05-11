class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+[a-z]+\z/i 
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  
  # these are the two additional columns added: system = Renewable Energy System Tyoe
  # init_rading = initial meter reading in kWh
  validates :system, presence: true
  validates :init_reading, presence: true

  has_secure_password
  validates :password, length: { minimum: 10 }
end

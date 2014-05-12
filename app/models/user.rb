class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  
  # these are the two additional columns added: system = Renewable Energy System Tyoe
  # init_rading = initial meter reading in kWh
  validates :system, presence: true,
                     inclusion: { in: 1..6 }
  validates :init_reading, presence: true,
                           inclusion: { in: 0..1000000000 }
  has_secure_password
  validates :password, length: { minimum: 10 }
end

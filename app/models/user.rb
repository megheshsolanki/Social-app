class User < ApplicationRecord
    has_secure_password
    before_create :generate_otp

    
    validates :name , presence: true
    validates :email , presence: true 
    validates :email , email: true
    validates :password_digest , presence: true, format: { with: /\A
    (?=.{8,})
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]]) /x, message: 'must contain an uppercase letter, a lowercase letter and a special letter'}
    validates :phone_number , presence: true, numericality: {only_integer: true} , length: { is: 10}
    
    password_format = /\A
    (?=.{8,})
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]])
    /x
    has_many :articles, dependent: :destroy
    has_many :comments, dependent: :destroy
    
    
    has_many :friendships, dependent: :destroy
    has_many :friends, through: :friendships 
    
    has_many :notifications, dependent: :destroy
    has_many :notify, through: :notifications
    
    has_many :blocked_user, dependent: :destroy
    has_many :blocked_by, through: :blocked_user
    
  

    has_many :shared_articles, dependent: :destroy 
    
    def generate_otp
        self.otp = '%04d' % SecureRandom.random_number(10000)
        self.otp_sent_at = Time.zone.now
    end
end

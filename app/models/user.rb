class User < ApplicationRecord
    has_secure_password
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
end

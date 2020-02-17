class User < ApplicationRecord
  has_secure_password
  has_many :stocks
  has_many :transactions
  validates :email, presence: true, uniqueness: true
end

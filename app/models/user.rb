class User < ApplicationRecord
  has_many :locations

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true
end

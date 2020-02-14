class User < ApplicationRecord
  belongs_to :pair

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true

  delegate :finished?, to: :pair

  def serializable_hash(options = {})
    super(options).except('verification_code')
  end
end

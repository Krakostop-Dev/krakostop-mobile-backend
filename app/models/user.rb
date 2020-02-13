class User < ApplicationRecord
  has_many :locations
  belongs_to :pair

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true

  delegate :finished?, to: :pair

  def latest_location
    locations.merge(Location.latest)
  end
end

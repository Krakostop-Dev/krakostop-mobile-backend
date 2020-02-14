class Pair < ApplicationRecord
  has_many :users
  has_many :locations

  validate :validate_users_amount

  private

  def validate_users_amount
    return if users.size <= 2

    errors.add(:users, 'too many users in pair')
  end

  def latest_location
    locations.merge(Location.latest)
  end
end
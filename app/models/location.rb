class Location < ApplicationRecord
  acts_as_mappable

  belongs_to :user

  validates :lat, presence: true
  validates :lng, presence: true

  scope :latest, -> {
    find_by_sql(
      <<-SQL
        SELECT locations.* 
        FROM (
          SELECT MAX(locations.created_at) as created_at_max, user_id
          FROM locations
          GROUP BY user_id
        ) latest
        JOIN locations 
        ON locations.user_id = latest.user_id 
        AND locations.created_at = latest.created_at_max
      SQL
    )
  }
end
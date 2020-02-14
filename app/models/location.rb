class Location < ApplicationRecord
  acts_as_mappable

  belongs_to :pair

  validates :lat, presence: true
  validates :lng, presence: true

  scope :latest, lambda {
    find_by_sql(
      <<-SQL
        SELECT locations.*
        FROM (
          SELECT MAX(locations.created_at) as created_at_max, pair_id
          FROM locations
          GROUP BY pair_id
        ) latest
        JOIN locations
        ON locations.pair_id = latest.pair_id
        AND locations.created_at = latest.created_at_max
      SQL
    )
  }
end

FactoryBot.define do
  factory :attraction do
        sequence(:name) { |n| "name #{n}" }
        sequence(:shortDescription) { |n| "shortDescription #{n}" }
        sequence(:fullDescription) { |n| "fullDescription #{n}" }
        sequence(:place) { |n| "place #{n}" }
        sequence(:time) { |n| "time #{n}" }
  end
end
    
FactoryBot.define do
  factory :day do
    sequence(:date) { |n| "day#{n}" }
    sequence(:name) { |n| "name #{n}" }


    trait :with_attractions do
      after :create do |day|
        create_list :attraction, 3, day: day
      end
    end
  end
end
  
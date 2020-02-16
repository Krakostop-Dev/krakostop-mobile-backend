FactoryBot.define do
  factory :pair do
    sequence(:finished) { false }
    sequence(:pair_nr) { |n| n }

    trait :with_users do
      after :create do |pair|
        create_list :user, 2, :with_code, pair: pair
      end
    end

    trait :with_locations do
      after :create do |pair|
        create_list :location, 3, pair: pair
      end
    end
  end
end

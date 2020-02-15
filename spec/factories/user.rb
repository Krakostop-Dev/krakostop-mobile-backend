FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name) { |n| "last_name#{n}" }
    sequence(:email) { |n| "email#{n}@example.org" }
    verification_code { nil }
    phone { rand(10**9).to_s }
    city { 'Kraków' }
  end

  trait :with_code do
    verification_code { rand(10**6).to_s }
  end
end
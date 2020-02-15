FactoryBot.define do
  factory :pair do
    sequence(:finished) { false }
    sequence(:pair_nr) { |n| n }
  end
end

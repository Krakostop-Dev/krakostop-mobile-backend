FactoryBot.define do
  factory :location do
    lat { BigDecimal(rand(36..52)) }
    lng { BigDecimal(rand(0..26)) }
    distance_left { rand(0..2000).to_i }
    sender { build(:user) }
  end
end

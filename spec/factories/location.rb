FactoryBot.define do
  factory :location do
    lat { BigDecimal(rand(36..52)) }
    lng { BigDecimal(rand(0..26)) }
  end
end

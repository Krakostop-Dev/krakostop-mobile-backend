FactoryBot.define do
  factory :location do
    lat { BigDecimal(rand(180) - 90) }
    lng { BigDecimal(rand(360) - 180) }
  end
end

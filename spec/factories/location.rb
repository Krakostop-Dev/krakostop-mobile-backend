FactoryBot.define do
  factory :location do
    lat { BigDecimal(rand(-90..89)) }
    lng { BigDecimal(rand(-180..179)) }
  end
end

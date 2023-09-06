FactoryBot.define do
  factory :player do
    fname { Faker::Name.first_name }
    lname { Faker::Name.last_name }
  end
end

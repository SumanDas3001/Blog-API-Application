FactoryBot.define do
  factory :user do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password }
    name { Faker::Internet.username }
  end
end

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    body { 'Body..' }
    status { 'read' }
    association :user
  end
end

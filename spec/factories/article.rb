FactoryBot.define do
    
    factory :article do
        title { Faker::Lorem.sentence }
        body { Faker::Lorem.paragraph}
        privacy { "public" }
        association :user, factory: :user
    end
end
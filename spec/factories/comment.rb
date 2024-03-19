FactoryBot.define do
    factory :comment do
      body {Faker::Lorem.sentence}
      association :article, factory: :article
      association :user, factory: :user
    end
  end
FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      password { Faker::Internet.password(min_length: 8,mix_case: true, special_characters: true) }
      phone_number { "0123456789" }
      otp { generate_otp }
    end
    def generate_otp 
      '%04d' % SecureRandom.random_number(10000)
    end
  end
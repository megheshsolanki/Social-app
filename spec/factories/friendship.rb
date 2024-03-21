FactoryBot.define do
    factory :friendship do
      status {"pending"} 
      association :sender, factory: :user
      association :reciever, factory: :user
    end
  end
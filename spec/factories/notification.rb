FactoryBot.define do
    factory :notification do
      association :sender, factory: :user
      association :reciever, factory: :user
      notification_type {"friend request"}
    end
  end
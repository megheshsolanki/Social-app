# # Create users
user1 = User.create!(email: 'asd@gmail.com', name: 'asd', password: 'Password@',phone_number: "1234567890")
user2 = User.create!(email: 'qwe@gmail.com', name: 'qwe', password: 'Password@',phone_number: "1234567890")
user3 = User.create!(email: 'ert@gmail.com', name: 'ert', password: 'Password@',phone_number: "1234567890")

# Create articles for user1
3.times do
  user1.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "only_me")
end
3.times do
  user1.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "friends")
end
3.times do
  user1.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "public")
end

# Create articles for user2
3.times do
    user2.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "only_me")
  end
  3.times do
    user2.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "friends")
  end
  3.times do
    user2.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "public")
  end
# Create articles for user3
3.times do
    user3.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "only_me")
  end
  3.times do
    user3.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "friends")
  end
  3.times do
    user3.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3),privacy: "public")
  end

friend1 = Friendship.create!(sender_id: 1,reciever_id: 2, status: "accepted")
friend2 = Friendship.create!(sender_id: 2,reciever_id: 1, status: "accepted")
friend3 = Friendship.create!(sender_id: 1,reciever_id: 3, status: "accepted")
friend4 = Friendship.create!(sender_id: 3,reciever_id: 1, status: "accepted")


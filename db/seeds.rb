# Create users
user1 = User.create!(email: 'asd@gmail.com', name: 'asd', password: 'Password@',phone_number: "1234567890")
user2 = User.create!(email: 'qwe@gmail.com', name: 'qwe', password: 'Password@',phone_number: "1234567890")

# Create articles for user1
10.times do
  user1.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3))
end

# Create articles for user2
10.times do
  user2.articles.create!(title: Faker::Lorem.sentence(word_count: 7), body: Faker::Lorem.paragraph(sentence_count: 3))
end


FactoryBot.create_list(:user, 2, :with_organization)

User.all.each do |user|
  FactoryBot.create(:organization, user: user)
  FactoryBot.create_list(:micropost, 10, :with_image, author: user)
end

FactoryBot.create(:user, :superadmin)

FactoryBot.create_list(:feedback, 30)

FactoryBot.create_list(:category, 8)

Category.all.each do |category|
  FactoryBot.create_list(:post, 5, :with_image, category: category)
end

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:name) { |n| "User_#{n}"}
    email { "#{username}@server.com" }
    password { 'password' }
    address { '2-3-4 aoenu' }

    factory :admin do
      after(:create) { |u| u.add_role(:admin) }
    end
  end
end

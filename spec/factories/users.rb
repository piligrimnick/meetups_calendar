FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    username { FFaker::Internet.user_name }
    name { FFaker::NameRU.first_name_male }
    middle_name { FFaker::NameRU.middle_name_female }
    last_name { FFaker::NameRU.last_name_male }

    password { FFaker::Internet.password }
  end
end

FactoryBot.define do
  sequence :email do |n|
		"test#{n}@test.com"
  end
  sequence :name do |n|
    "muyaszed#{n}"
  end
  factory :user do
    username {generate :name}
  	email {generate :email}
    password 'abcdef'
    password_confirmation 'abcdef'

  end
end

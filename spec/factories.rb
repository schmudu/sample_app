FactoryGirl.define do 
  factory :user do
    name        "Patrick Lee"
    email       "patrick@abc.com"
    password    "foobar"
    password_confirmation "foobar"
  end
end
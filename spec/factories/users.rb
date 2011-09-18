FactoryGirl.define do
  factory :user do
    provider "twitter"
    provider_uid "12345"
    provider_token { Forgery::Basic.encrypt }
    provider_secret { Forgery::Basic.encrypt }
    sequence(:username) {|n| "user_#{n}" }
    sequence(:name) {|n| "User #{n}" }
    avatar_url "http://a1.twimg.com/sticky/default_profile_images/default_profile_6_normal.png"
  end
end

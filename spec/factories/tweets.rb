FactoryGirl.define do
  factory :tweet do
    user
    username { user.username }
    flight_number(777).ignore
    tweeted_at { 10.minutes.ago }
    text do
      ["About to take flight #{flight_number}.",
       "Taking ##{flight_number} now.",
       "Hello jetBlue #{flight_number} !"].sample
    end

    factory :stranger_tweet do
      user nil
      sequence(:n) {|n| "stranger_#{n}" }
    end
  end
end

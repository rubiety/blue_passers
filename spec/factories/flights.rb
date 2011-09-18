FactoryGirl.define do
  factory :flight do
    sequence(:number) {|n| n }
    association :origin, :factory => :airport
    association :destination, :factory => :airport
    start_at { 12.hours.ago }
    actual_start_at { start_at }
    end_at { 8.hours.ago }
    actual_end_at { end_at }
    distance { 1000 }
  end
end

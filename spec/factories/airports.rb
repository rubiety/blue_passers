FactoryGirl.define do
  factory :airport do
    sequence(:code) {|n| "A0#{n}"[-3..-1] }
    sequence(:city_name) {|n| Forgery::Address.city }
    name { "#{city_name} Airport" }
    time_zone_name "Eastern Time (US & Canada)"
    time_zone_offset -5
    latitude 40.639751
    longitude -73.778925
    altitude 13
  end
end

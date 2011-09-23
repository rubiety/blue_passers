class Airport < ActiveRecord::Base
  has_many :flights_as_origin, :class_name => "Flight", :foreign_key => "origin_id"
  has_many :flights_as_destination, :class_name => "Flight", :foreign_key => "destination_id"
  has_many :flights, :class_name => "Flight", :finder_sql => proc { "SELECT DISTINCT * FROM flights WHERE origin_id = #{id} or destination_id = #{id}" }

  has_friendly_id :code_with_city_name, :use_slug => true

  scope :ordered_by_checkins, order("check_ins_as_origin_count + check_ins_as_destination_count desc")

  scope :with_distance_to, lambda {|airport|
    origin_lat = airport.latitude * Math::PI / 180
    origin_lng = airport.longitude * Math::PI / 180

    select("*, 
      (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(airports.latitude))*COS(RADIANS(airports.longitude))+
      COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(airports.latitude))*SIN(RADIANS(airports.longitude))+
      SIN(#{origin_lat})*SIN(RADIANS(airports.latitude)))*3963) AS distance
    ")
  }

  def to_s
    code
  end

  def code_with_city_name
    "#{code} - #{city_name}"
  end

  def check_ins_as_origin
    CheckIn.where(:flight_id => flights_as_origin_ids)
  end

  def check_ins_as_destination
    CheckIn.where(:flight_id => flights_as_destination_ids)
  end

  def check_ins
    CheckIn.where(:flight_id => (flights_as_origin_ids + flights_as_destination_ids))
  end

  def flights_count
    flights_as_origin_count + flights_as_destination_count
  end

  def check_ins_count
    check_ins_as_origin_count + check_ins_as_destination_count
  end

  def update_check_ins_count
    update_attribute(:check_ins_as_origin_count, check_ins_as_origin.count)
    update_attribute(:check_ins_as_destination_count, check_ins_as_destination.count)
  end

  def update_unique_visitors_count
    update_attribute(:unique_visitors_count, check_ins.count("DISTINCT user_id"))
  end
  
  def time_zone
    ActiveSupport::TimeZone[time_zone_name] if time_zone_name
  end

  def distance_to(other_airport)
    Airport.with_distance_to(other_airport).where(:id => id).first.try(:distance)
  end
end

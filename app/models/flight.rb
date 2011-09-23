class Flight < ActiveRecord::Base
  NOTIFY_MINUTES = 40

  belongs_to :origin, :class_name => "Airport", :counter_cache => :flights_as_origin_count
  belongs_to :destination, :class_name => "Airport", :counter_cache => :flights_as_destination_count
  has_many :check_ins
  has_many :users, :through => :check_ins

  scope :recent, order("last_check_in_at desc")
  scope :for_tweet_notification, lambda {
    where(:tweeted_passengers_at => nil).where("start_at BETWEEN ? AND ?", Time.zone.now, NOTIFY_MINUTES.minutes.from_now).where("check_ins_count > 1")
  }

  has_friendly_id :description, :use_slug => true

  def self.by_number_and_day(number, date)
    where(:number => number).where("DATE(start_at) = DATE(?)", date).first
  end

  def self.upcoming_by_number(number, time)
    where(:number => number).where("start_at >= ? AND start_at <= ?", (time - 2.hours), (time + 22.hours)).first
  end

  def to_s
    "#{number} #{origin}->#{destination}"
  end

  def description
    "#{number} #{origin}->#{destination} on #{local_start_at}"
  end

  def local_start_at
    start_at.in_time_zone(origin.time_zone) if start_at and origin
  end

  def local_end_at
    end_at.in_time_zone(destination.time_zone) if end_at and destination
  end

  def local_last_check_in_at
    last_check_in_at.in_time_zone(ActiveSupport::TimeZone["Pacific Time (US & Canada)"])
  end

  def self.ensure_exists_from_jetblue(jetblue_flight)
    (by_number_and_day(jetblue_flight.number, jetblue_flight.start_at) || new).tap do |flight|
      origin_airport = Airport.find_or_create_by_code(jetblue_flight.origin_airport_code)
      destination_airport = Airport.find_or_create_by_code(jetblue_flight.destination_airport_code)

      flight.update_attributes(
        :number => jetblue_flight.number,
        :origin => origin_airport,
        :destination => destination_airport,
        :start_at => jetblue_flight.start_at,
        :actual_start_at => jetblue_flight.actual_start_at,
        :end_at => jetblue_flight.end_at,
        :actual_end_at => jetblue_flight.actual_end_at,
        :distance => origin_airport.distance_to(destination_airport)
      )
    end
  end

  def tweeted_passengers!
    update_attribute(:tweeted_passengers_at, Time.zone.now)
  end
end

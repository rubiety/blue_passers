class Flight < ActiveRecord::Base
  belongs_to :origin, :class_name => "Airport", :counter_cache => :flights_as_origin_count
  belongs_to :destination, :class_name => "Airport", :counter_cache => :flights_as_destination_count
  has_many :check_ins

  scope :recent, order("last_check_in_at desc")

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
    "#{number} #{origin}->#{destination} on #{start_at}"
  end

  def self.ensure_exists_from_jetblue(jetblue_flight)
    (by_number_and_day(jetblue_flight.number, jetblue_flight.start_at) || new).tap do |flight|
      flight.update_attributes(
        :number => jetblue_flight.number,
        :origin => Airport.find_or_create_by_code(jetblue_flight.origin_airport_code),
        :destination => Airport.find_or_create_by_code(jetblue_flight.destination_airport_code),
        :start_at => jetblue_flight.start_at,
        :actual_start_at => jetblue_flight.actual_start_at,
        :end_at => jetblue_flight.end_at,
        :actual_end_at => jetblue_flight.actual_end_at,
        :distance => 2000
      )
    end
  end
end

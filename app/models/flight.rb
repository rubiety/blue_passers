class Flight < ActiveRecord::Base
  belongs_to :origin, :class_name => "Airport"
  belongs_to :destination, :class_name => "Airport"

  scope :recent, order("last_check_in_at desc")

  def self.by_number_and_day(number, date)
    where(:number => number).where("DATE(start_at) = DATE(?)", date).first
  end

  def to_s
    "JBU#{number} #{origin} -> #{destination}"
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

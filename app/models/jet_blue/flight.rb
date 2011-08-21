class JetBlue::Flight
  attr_accessor :number
  attr_accessor :status
  attr_accessor :origin_airport_code
  attr_accessor :destination_airport_code
  attr_accessor :start_at
  attr_accessor :actual_start_at
  attr_accessor :end_at
  attr_accessor :actual_end_at

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value) if respond_to?(key.to_sym)
    end
  end

  def to_s
    "#{number} #{origin_airport_code}->#{destination_airport_code} on #{start_at}"
  end

  def self.upcoming_by_number(number, time = Time.zone.now)
    todays_flight = by_number(number, time)
    todays_flight = nil if todays_flight.start_at < (time - 3.hours)  # Allow for today's flight if it took off less than 3 hours from "now"

    if todays_flight
      todays_flight
    elsif tomorrows_flight = by_number(number, time + 1.day)
      tomorrows_flight
    end
  end

  def self.by_number(number, date = Time.zone.now)
    mechanize = Mechanize.new
    mechanize.get "http://www.jetblue.com/flightstatus/flightstatussched.aspx?FlightDate=#{date.strftime('%m/%d/%Y')}&FlightNum=#{number}" do |page|
      table = page.search("#fsSchedTable")[0]
      flight_rows = table.css("tr")[2..-1]
      raise ArgumentError, "#{flight_rows.size} flights were found!" if flight_rows.size != 1

      flight_row = flight_rows.first
      columns = flight_row.css("td")
      raise ArgumentError, "Expanded 8 columns but got #{columns.size}." if columns.size != 8

      origin_airport_code = columns[2].content.strip
      origin_airport = Airport.find_by_code(origin_airport_code)

      destination_airport_code = columns[5].content.strip
      destination_airport = Airport.find_by_code(destination_airport_code)

      return new(
        :number => columns[0].content.strip.to_i,
        :status => columns[1].content.strip.split("\n").first.strip,
        :origin_airport_code => origin_airport_code,
        :destination_airport_code => destination_airport_code,
      ).tap do |flight|
        flight.start_at = origin_airport.time_zone.parse(columns[3].content.strip) if origin_airport
        flight.actual_start_at = origin_airport.time_zone.parse(columns[4].content.strip) if origin_airport
        flight.end_at = destination_airport.time_zone.parse(columns[6].content.strip) if destination_airport
        flight.actual_end_at = destination_airport.time_zone.parse(columns[7].content.strip) if destination_airport
      end
    end
  end
end

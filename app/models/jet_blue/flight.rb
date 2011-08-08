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

  # 416
  def self.by_number(number, date = Time.now)
    mechanize = Mechanize.new
    mechanize.get "http://www.jetblue.com/flightstatus/flightstatussched.aspx?FlightDate=#{date.strftime('%m/%d/%Y')}&FlightNum=#{number}" do |page|
      table = page.search("#fsSchedTable")[0]
      flight_rows = table.css("tr")[2..-1]
      raise ArgumentError, "#{flight_rows.size} flights were found!" if flight_rows.size != 1

      flight_row = flight_rows.first
      columns = flight_row.css("td")
      raise ArgumentError, "Expanded 8 columns but got #{columns.size}." if columns.size != 8

      return new(
        :number => columns[0].content.strip.to_i,
        :status => columns[1].content.strip.split("\n").first.strip,
        :origin_airport_code => columns[2].content.strip,
        :start_at => DateTime.parse(columns[3].content.strip),
        :actual_start_at => DateTime.parse(columns[4].content.strip),
        :destination_airport_code => columns[5].content.strip,
        :end_at => DateTime.parse(columns[6].content.strip),
        :actual_end_at => DateTime.parse(columns[7].content.strip)
      )
    end
  end
end

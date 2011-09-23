class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :check_ins

  default_scope order("id desc")
  scope :with_check_ins, where("check_ins_count > 0")
  scope :private, where(:private => true)
  scope :public, where(:private => false)
  
  FLIGHT_MATCHER = /(\#\d+|B6\d+|\#JBU\d+|Flight ?\d+|JetBlue ?\d+|Flt ?\d+)/i
  ALLOW_CHECK_IN_RANGE = Date.new(2011, 8, 21)..Date.new(2011, 11, 23)

  def local_tweeted_at
    # Assume Pacific Time on the tweet (gives us the most flexibility)
    tweeted_at.in_time_zone(ActiveSupport::TimeZone["Pacific Time (US & Canada)"])
  end

  def self.from_twitter(raw_tweet)
    the_user = User.find_by_username(raw_tweet.user.screen_name)

    create!(
      :private => false,
      :user => the_user,
      :username => raw_tweet.user.screen_name,
      :text => raw_tweet.text,
      :reference => raw_tweet.id_str,
      :reply_to_username => raw_tweet.in_reply_to_screen_name,
      :tweeted_at => Time.zone.parse(raw_tweet.created_at)
    )
  end

  def self.from_direct_message(raw_dm)
    the_user = User.find_by_username(raw_dm.sender_screen_name)

    create!(
      :private => true,
      :user => the_user,
      :username => raw_dm.sender_screen_name,
      :text => raw_dm.text,
      :reference => raw_dm.id_str,
      :tweeted_at => Time.zone.parse(raw_dm.created_at)
    )
  end

  def process_check_ins
    return unless user
    return unless ALLOW_CHECK_IN_RANGE === local_tweeted_at.to_date

    FlightMaster.logger.info "  Processing Tweet [#{id}] on #{tweeted_at}: \"#{text}\"..."

    self.class.extract_flight_references(text).each do |flight_reference|
      FlightMaster.logger.info "    Found Reference: \"#{flight_reference}\""

      flight_reference.gsub!(/[^0-9]/, "")

      begin
        if flight = Flight.upcoming_by_number(flight_reference, local_tweeted_at)
          FlightMaster.logger.info "      Found existing flight for #{flight_reference}: [#{flight.id}] #{flight.to_s}"
          user.check_ins.create!(:flight => flight, :tweet => self)

        elsif jetblue_flight = JetBlue::Flight.upcoming_by_number(flight_reference, local_tweeted_at)
          FlightMaster.logger.info "      Found flight on JetBlue for #{flight_reference}: #{jetblue_flight.to_s}"
          flight = Flight.ensure_exists_from_jetblue(jetblue_flight)

          FlightMaster.logger.info "        Created flight from JetBlue #{flight_reference}: [#{flight.id}] #{flight.to_s}"
          user.check_ins.create!(:flight => flight, :tweet => self)
        else
          FlightMaster.logger.info "      !! Could not find flight for #{flight_reference} on #{local_tweeted_at}"
        end

      rescue ArgumentError => e
        FlightMaster.logger.info "      !! ArgumentError: #{e.to_s}"
      end
      
    end
  end

  def self.extract_flight_references(text)
    text.scan(FLIGHT_MATCHER).flatten
  end
end

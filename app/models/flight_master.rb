class FlightMaster
  TWEET_CONSUMPTION_LIMIT = 20

  class_inheritable_accessor :logger
  self.logger = Logger.new(Rails.root.join("log/flight_master.log"))

  def logger
    @logger || self.class.logger
  end

  def self.with_twitter
    settings = YAML::load_file(Rails.root.join("config/twitter.yml"))
    settings = settings["flightmaster_#{Rails.env}"] if settings

    Twitter.configure do |config|
      config.consumer_key = settings["key"]
      config.consumer_secret = settings["secret"]
      config.oauth_token = settings["user_token"]
      config.oauth_token_secret = settings["user_secret"]
    end

    if block_given?
      yield.tap do
        Twitter.reset
      end
    end
  end

  def self.home_timeline(options = {})
    with_twitter do
      Twitter.home_timeline(options)
    end
  end

  def self.direct_messages(options = {})
    with_twitter do
      Twitter.direct_messages(options)
    end
  end

  def self.follow(username)
    with_twitter do
      Twitter.follow(username)
    end
  end

  def self.unfollow(username)
    with_twitter do
      Twitter.unfollow(username)
    end
  end

  def self.consume_tweets
    tweet_since_id = Tweet.public.first.try(:reference)
    logger.info "[#{Time.zone.now}] Consuming Tweets Since [#{tweet_since_id}]"

    tweets = home_timeline(:since_id => tweet_since_id || 0, :count => TWEET_CONSUMPTION_LIMIT).reverse
    tweets.each do |raw|
      Tweet.from_twitter(raw).process_check_ins
    end

    logger.info "[#{Time.zone.now}] Tweet Consumption Complete"
    logger.info ""

    dm_since_id = Tweet.private.first.try(:reference)
    logger.info "[#{Time.zone.now}] Consuming Direct Messages Since [#{dm_since_id}]"

    dms = direct_messages(:since_id => dm_since_id || 0, :count => TWEET_CONSUMPTION_LIMIT).reverse
    dms.each do |raw|
      Tweet.from_direct_message(raw).process_check_ins
    end

    logger.info "[#{Time.zone.now}] Direct Message Consumption Complete"
    logger.info ""
  end

end

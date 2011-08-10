class FlightMaster

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
    options = options.except(:since_id) if options[:since_id].nil? # TODO

    with_twitter do
      Twitter.home_timeline(options)
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
    home_timeline(:since_id => Tweet.first.try(:reference), :count => 20).reverse.each do |raw|
      Tweet.from_twitter(raw).process_check_ins
    end
  end

end

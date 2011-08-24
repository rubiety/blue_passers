class User < ActiveRecord::Base
  has_many :check_ins
  has_many :flights, :through => :check_ins

  after_create :follow_by_flight_master

  scope :leaderboard, where(:show_on_leaderboard => true).order("distance_sum desc")

  has_friendly_id :username, :use_slug => true

  def self.usernames
    select(:username).map(&:username)
  end

  def to_s
    name
  end
  
  def handle
    "@#{username}"
  end

  def airports
    Airport.where(:id => (flights.map(&:origin_id) + flights.map(&:destination_id)).uniq)
  end

  def self.initialize_with_omniauth(authentication)
    find_or_initialize_by_provider_and_provider_uid(authentication["provider"], authentication["uid"]).tap do |user|
      user.provider = authentication["provider"]
      user.provider_uid = authentication["uid"]  
      user.provider_token = authentication["credentials"]["token"]
      user.provider_secret = authentication["credentials"]["secret"]
      user.name = authentication["user_info"]["name"] 
      user.username = authentication["user_info"]["nickname"]
      user.location = authentication["user_info"]["location"]
      user.description = authentication["user_info"]["description"]
      user.website = authentication["user_info"]["urls"]["Website"]
      user.avatar_url = authentication["user_info"]["image"]
    end
  end

  def with_twitter
    settings = YAML::load_file(Rails.root.join("config/twitter.yml"))
    settings = settings[Rails.env.to_s] if settings

    Twitter.configure do |config|
      config.consumer_key = settings["key"]
      config.consumer_secret = settings["secret"]
      config.oauth_token = provider_token
      config.oauth_token_secret = provider_secret
    end

    if block_given?
      yield.tap do
        Twitter.reset
      end
    end
  end

  def update_distance_sum
    update_attribute(:distance_sum, flights.sum(:distance))
  end

  def update_airports_count
    update_attribute(:airports_count, airports.count)
  end


  protected

  def follow_by_flight_master
    FlightMaster.follow(username)
  end
end

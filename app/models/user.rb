class User < ActiveRecord::Base
  has_many :check_ins
  has_many :flights, :through => :check_ins

  def to_s
    name
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
end

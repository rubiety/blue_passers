class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :check_ins

  default_scope order("id desc")
  scope :with_check_ins, where("check_ins_count > 0")

  def self.from_twitter(raw_tweet)
    the_user = User.find_by_username(raw_tweet.user.screen_name)

    create!(
      :user => the_user,
      :username => raw_tweet.user.screen_name,
      :text => raw_tweet.text,
      :reference => raw_tweet.id_str,
      :reply_to_username => raw_tweet.in_reply_to_screen_name,
      :tweeted_at => DateTime.parse(raw_tweet.created_at)
    )
  end

  def process_check_ins
    return unless user

    text.scan(/(\#JBU\d+|Flight ?\d+)/i).flatten.each do |flight_reference|
      flight_reference.gsub!(/[^0-9]/, "")

      if jetblue_flight = JetBlue::Flight.by_number(flight_reference)
        flight = Flight.ensure_exists_from_jetblue(jetblue_flight)
        
        user.check_ins.create!(
          :flight => flight,
          :tweet => self
        )
      end
    end
  end
end

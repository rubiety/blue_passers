class CheckIn < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :flight, :counter_cache => true, :touch => :last_check_in_at
  belongs_to :tweet, :counter_cache => true

  default_scope order("id desc")
  scope :recent, limit(20)
  scope :exposed, joins(:user).where(:users => {:expose_flight_history => true})

  after_create :update_user_stats
  after_create :update_airport_stats
  
  def to_s
    "#{user} on #{flight}"
  end


  protected

  def update_user_stats
    user.update_distance_sum
  end

  def update_airport_stats
    flight.origin.try(:update_check_ins_count)
    flight.destination.try(:update_check_ins_acount)
  end
end

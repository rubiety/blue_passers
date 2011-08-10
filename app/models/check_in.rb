class CheckIn < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :flight, :counter_cache => true, :touch => :last_check_in_at
  belongs_to :tweet, :counter_cache => true

  default_scope order("id desc")
  scope :recent, limit(20)

  after_create :update_user_stats
  
  def to_s
    "#{user} on #{flight}"
  end


  protected

  def update_user_stats
    user.update_distance_sum
  end
end

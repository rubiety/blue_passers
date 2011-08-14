module ApplicationHelper
  def twitter_user_url(user)
    "http://twitter.com/#{user.username}"
  end
end

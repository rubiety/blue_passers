class HomeController < ApplicationController
  def index
    @leaderboard_users = User.leaderboard
    @recent_check_ins = CheckIn.recent
  end
end

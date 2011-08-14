class HomeController < ApplicationController
  def index
    @leaderboard_users = User.leaderboard
    @recent_check_ins = CheckIn.recent

    flash[:notice] = "Note: The BluePass doesn't begin until August 22nd. We'll begin tracking flights then! "
  end
end

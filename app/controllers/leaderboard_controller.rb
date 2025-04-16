class LeaderboardController < ApplicationController
  def index
    @scores = Score.order(points: :desc).limit(10)
    @active_users = User.where(active: true)
  end

  def active
    @active_users = User.where(active: true)
  end
end

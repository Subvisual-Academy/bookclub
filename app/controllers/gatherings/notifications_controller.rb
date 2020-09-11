class Gatherings::NotificationsController < ApplicationController
  before_action :require_moderator

  def create
    @gathering = Gathering.find(params[:gathering_id])

    SlackNotifier.notify_minute(@gathering.date, gatherings_url)

    redirect_to gatherings_path, notice: "Notification was succesfully sent"
  end

  private

  def require_moderator
    return if current_user&.moderator

    head :unauthorized
  end
end

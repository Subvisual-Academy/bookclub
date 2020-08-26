class Gatherings::NotificationsController < ApplicationController
  before_action :require_login, only: %i[create]

  def create
    @gathering = Gathering.find(params[:gathering_id])

    SlackNotifier.notify_minute(@gathering.date, gathering_url(@gathering))

    redirect_to gatherings_path, notice: "Notification was succesfully sent"
  end
end

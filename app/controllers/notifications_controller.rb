class NotificationsController < ApplicationController

  def create
    @gathering = Gathering.find(params[:gathering][:id])

    SlackNotifier.notify_minute(@gathering.date, gathering_url(@gathering))

    redirect_to gatherings_path, notice: "Notification was succesfully sent"
  end
end

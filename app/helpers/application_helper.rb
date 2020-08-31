module ApplicationHelper
  def show_date_month(gathering)
    Date::MONTHNAMES[gathering.date.month]
  end

  def send_notification_button(current_user, gathering)
    return unless current_user&.moderator

    button_to "Send Slack Notification", gathering_notifications_path(gathering),
              class: "gatherings-Submit", data: { confirm: "Are you sure?" }
  end
end

module ApplicationHelper
  def show_date_month(gathering)
    Date::MONTHNAMES[gathering.date.month]
  end

  def send_notification_button(current_user, gathering)
    return unless current_user&.moderator

    button_to "Send Slack Notification",
              gathering_notifications_path(gathering),
              class: "comp-button",
              data: { confirm: "Are you sure you want to send a notification to slack?" }
  end

  def book_author(book)
    return "Unknown" if book.author.nil?

    book.author
  end

  def goodreads_button(book)
    escaped_title = CGI.escape(book.title)

    link_to "Goodreads", "https://www.goodreads.com/search?q=#{escaped_title}", class: "comp-button", target: "_blank", rel: "noopener"
  end
end

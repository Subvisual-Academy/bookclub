module SlackNotifier
  class << self
    def notify_minute(date, url)
      @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: ENV["SLACK_CHANNEL"], username: ENV["BOT_NAME"]

      @slack_notifier.ping(text: "The books from the *#{date.strftime('%B %-dth')}* gathering are now available! Check them out on: #{url} :book:")
    end

    def notify_start_of_week
      @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: ENV["SLACK_CHANNEL"], username: ENV["BOT_NAME"]

      @slack_notifier.ping(text: "*Reminder*: The Bookclub gathering is this week :book:")
    end

    def notify_day
      @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: ENV["SLACK_CHANNEL"], username: ENV["BOT_NAME"]

      @slack_notifier.ping(text: "*Reminder*: The Bookclub gathering is today :book:")
    end
  end
end

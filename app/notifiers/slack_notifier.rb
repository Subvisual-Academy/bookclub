module SlackNotifier
  def self.publish(date, url)
    @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: ENV["SLACK_CHANNEL"], username: "BookClub-bot"

    @slack_notifier.ping(text: "This books from *#{date.strftime('%d %B %Y')}* are available on: #{url} :book:")
  end
end

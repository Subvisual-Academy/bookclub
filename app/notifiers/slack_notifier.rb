module SlackNotifier
  def self.publish(root_url, date, path)
    @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: "#bot_testing", username: "BookClub-bot"

    @slack_notifier.ping(text: "A ata do bookclub de #{date} está disponível em: #{URI.join(root_url, path)}")
  end
end

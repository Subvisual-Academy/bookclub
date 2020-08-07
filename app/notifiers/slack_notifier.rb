module SlackNotifier
  def self.publish
    @slack_notifier ||= Slack::Notifier.new ENV["SLACK_URL"], channel: "#bot_testing", username: "BookClub-bot"

    @slack_notifier.ping(text: "A ata do bookclub já está disponível em: http://example.com")
  end
end

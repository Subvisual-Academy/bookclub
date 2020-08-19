namespace :gathering_notification do
  desc "Send a notification to slack when the week of the gathering starts"
  task start_of_week: :environment do
    SlackNotifier.notify_start_of_week
  end

  desc "Send a notification to slack when it's the day of the gathering"
  task day: :environment do
    SlackNotifier.notify_day
  end

end

desc "Send a notification to slack when it's the day of the gathering"
task notify_day: :environment do
  if Time.zone.today == Gathering.next_gathering_date
    SlackNotifier.notify_day
  end
end

desc "Send a notification to slack when the week of the gathering starts"
task notify_start_of_week: :environment do
  if Time.zone.today == Gathering.next_gathering_date.beginning_of_week
    SlackNotifier.notify_start_of_week
  end
end

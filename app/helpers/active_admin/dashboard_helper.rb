module ActiveAdmin::DashboardHelper
  def time_of_day_greeting
    name = current_admin_user.first_name
    time_greeting = greeting_wording
    ending = name.nil? ? '!' : ", #{name}!"
    time_greeting + ending
  end

  private

  def greeting_wording
    now = Time.now
    today = Date.today.to_time

    early_morning = today.beginning_of_day
    morning = today.beginning_of_day + 7.hours
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 21 )
    tomorrow = today.tomorrow

    if (early_morning..morning).cover? now
      'Early bird gets the worm'
    elsif (morning..noon).cover? now
      'Good Morning'
    elsif (noon..evening).cover? now
      'Good Afternoon'
    elsif (evening..night).cover? now
      'Good Evening'
    elsif (night..tomorrow).cover? now
      "Keep burning that midnight oil"
    end
  end
end

# frozen_string_literal: true

module PostsHelper
  # :reek:TooManyStatements
  # :reek:UtilityFunction
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def time_since_publication(post)
    time_difference = Time.now - post.published_at
    if time_difference < 1.hour
      "#{(time_difference / 60).to_i} minutes ago"
    elsif time_difference < 1.day
      "#{(time_difference / 3600).to_i} hours ago"
    elsif time_difference < 1.week
      "#{(time_difference / 86_400).to_i} days ago"
    elsif time_difference < 1.month
      "#{(time_difference / 604_800).to_i} weeks ago"
    elsif time_difference < 1.year
      "#{(time_difference / 2_419_200).to_i} months ago"
    else
      "#{(time_difference / 31_536_000).to_i} years ago"
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end

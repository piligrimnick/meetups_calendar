class ActivityDecorator < BaseDecorator
  def author
    "#{user.name} #{user.last_name}"
  end

  def show_duration?
    true
  end

  def duration_in_seconds
    end_at - start_at
  end

  def duration_in_minutes
    duration_in_seconds / 60
  end

  def duration_in_hours
    duration_in_minutes / 60
  end

  def human_readable_duration
    # todo: do realisation
    duration_in_seconds
  end

  def types
    Activity::ACTIVITY_TYPES.map { |v| [v.titleize, v] }
  end
end

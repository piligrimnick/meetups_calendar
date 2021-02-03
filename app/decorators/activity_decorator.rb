class ActivityDecorator < BaseDecorator
  def author
    "#{user.name} #{user.last_name}"
  end

  def show_duration?
    %w[hackathon].include?(activity_type)
  end

  def show_logo?
    %w[internal_meetup speech_draft].include?(activity_type)
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
end

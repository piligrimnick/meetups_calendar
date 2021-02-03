class TimeIntervalValidator
  def initialize(record)
    @record = record
  end

  def validate
    validate_start_time_in_past
    validate_time_interval
    validate_user_activities_intervals
  end

  private

  attr_reader :record

  def validate_start_time_in_past
    return if record.start_at >= Time.zone.now

    record.errors.add :start_at, "Start time cannot be in past"
  end

  def validate_time_interval
    return if record.start_at <= record.end_at

    record.errors.add :start_at, "Start time cannot be less than end time"
    record.errors.add :end_at, "End time cannot be more than start time"
  end

  def validate_user_activities_intervals
    return if record.user.blank?

    result = record.user.activities.any? { |activity|
      activity.end_at >= record.start_at || activity.start_at <= record.end_at
    }

    if result
      record.errors.add :start_at, "Start time must be past another activitiy ends"
      record.errors.add :end_at, "End time must be before another activity starts"
    end
  end
end

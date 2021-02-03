class TimeIntervalValidator
  def initialize(record)
    @record = record
  end

  def validate
    if record.start_at.blank?
      record.errors.add :start_at, "cannot be blank"
      return
    end
    if record.end_at.blank?
      record.errors.add :end_at, "cannot be blank"
      return
    end

    validate_start_time_in_past
    validate_time_interval
    validate_user_activities_intervals
  end

  private

  attr_reader :record

  def validate_start_time_in_past
    return if record.start_at >= Time.zone.now

    record.errors.add :start_at, "cannot be in past"
  end

  def validate_time_interval
    return if record.start_at <= record.end_at

    record.errors.add :start_at, "cannot be less than end time"
    record.errors.add :end_at, "cannot be more than start time"
  end

  def validate_user_activities_intervals
    return if record.user.blank?

    failure = record.user.activities.except(record).any? do |activity|
      next if record.created_at.present? && (record.id == activity.id)

      intersects?((activity.start_at..activity.end_at), (record.start_at..record.end_at))
    end

    if failure
      record.errors.add :start_at, "must be past your another activitiy ends"
      record.errors.add :end_at, "must be before your another activity starts"
    end
  end

  def intersects?(range, second_range)
    return nil if (range.max < second_range.begin or second_range.max < range.begin)
    [range.begin, second_range.begin].max..[range.max, second_range.max].min
  end
end

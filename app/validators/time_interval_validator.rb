class TimeIntervalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_presence(record, attribute, value)

    return if record.errors.present?

    validate_time_in_past(record, attribute, value)

    return if record.errors.present?

    validate_time_interval(record, attribute, value)

    return if record.errors.present?

    validate_user_activities_intervals(record, attribute, value)
  end

  private

  def validate_presence(record, attribute, value)
    record.errors.add(attribute, 'cannot be blank') if value.blank?
  end

  def validate_time_in_past(record, attribute, value)
    record.errors.add(attribute, 'cannot be in past') if value <= Time.zone.now
  end

  def validate_time_interval(record, attribute, value)
    return if record.start_at < record.end_at

    message = case attribute
              when :start_at then "cannot be less than end time"
              when :end_at then "cannot be more than start time"
              end

    record.errors.add attribute, message
  end

  def validate_user_activities_intervals(record, attribute, value)
    return if record.user.blank?

    failure = record.user.activities.except(record).any? do |activity|
      next if record.created_at.present? && (record.id == activity.id)

      intersects?((activity.start_at..activity.end_at), (record.start_at..record.end_at))
    end

    if failure
      message = case attribute
                when :start_at then "must be past your another activitiy ends"
                when :end_at then "must be past your another activitiy ends"
                end

      record.errors.add attribute, message
    end
  end

  def intersects?(range, second_range)
    return if (range.max < second_range.begin or second_range.max < range.begin)

    [range.begin, second_range.begin].max..[range.max, second_range.max].min
  end
end

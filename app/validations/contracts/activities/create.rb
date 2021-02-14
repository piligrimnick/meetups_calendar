module Contracts
  module Activities
    class Create < BaseContract
      option :user_repo, default: -> { User }

      params do
        required(:user_id).value(Types::Integer)

        required(:title).filled(Types::String)
        required(:short_description).filled(Types::String)
        required(:start_at).value(Types::Time)
        required(:end_at).value(Types::Time)
      end

      rule(:user_id) do |context:|
        context[:user] ||= user_repo.find_by(id: value)

        key.failure(:not_found) unless context[:user]
      end

      rule(:short_description).validate(max_size?: 255)

      rule(:start_at).validate(gt?: Time.zone.now)

      rule(:end_at, :start_at) do
        key.failure('must be after start at') if values[:end_at] < values[:start_at]
      end

      rule(:end_at, :start_at) do |context:|
        next key.failure('user must be set') if schema_error?(:user_id)

        failure = context[:user].activities.any? do |activity|
          range = (activity.start_at..activity.end_at)
          second_range = (values[:start_at]..values[:end_at])

          return if (range.max < second_range.begin or second_range.max < range.begin)

          [range.begin, second_range.begin].max..[range.max, second_range.max].min
        end

        if failure
          key(:end_at).failure("must be before your another activity starts")
          key(:start_at).failure("must be past your another activity ends")
        end
      end
    end
  end
end

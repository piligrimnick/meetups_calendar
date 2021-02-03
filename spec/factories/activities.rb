FactoryBot.define do
  factory :activity do
    user

    activity_type { Activity::ACTIVITY_TYPES.keys.sample }
    title { FFaker::Lorem.word }
    short_description { FFaker::Lorem.sentence }

    start_at { Time.zone.now + 1.day }
    end_at { Time.zone.now + 1.day + 1.hour }
  end
end

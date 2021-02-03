class Activity < ApplicationRecord
  ACTIVITY_TYPES = {
    "internal_meetup" => 0,
    "public_meetup" => 1,
    "speech_draft" => 2,
    "conference_speech" => 3,
    "hackathon" => 4
  }.freeze

  enum activity_type: ACTIVITY_TYPES

  belongs_to :user

  validates(:activity_type, :title, :short_description, :start_at, :end_at, presence: true)
  validates :short_description, length: {maximum: 255}

  validate { |activity| TimeIntervalValidator.new(activity).validate }
end

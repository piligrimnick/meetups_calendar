class Activity < ApplicationRecord
  DEFAULT_DECORATOR = ActivityDecorator

  ACTIVITY_TYPES = [
    "PublicMeetup",
    "SpeechDraft",
    "InternalMeetup",
    "ConferenceSpeech",
    "Hackathon"
  ].freeze

  belongs_to :user

  validates :title, :short_description, :start_at, :end_at, presence: true
  validates :short_description, length: {maximum: 255}
  validates :start_at, time_interval: true
  validates :end_at, time_interval: true

  DEFAULT_DECORATOR.instance_methods(false).each do |m|
    delegate(m, to: :decorated)
  end

  def decorated
    @decorated ||= DEFAULT_DECORATOR.new(self)
  end

  class << self
    # need for children policy lookup
    def policy_class
      ActivityPolicy
    end
  end
end

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

  validates_with ContractResolver

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

module Constraints
  class ApiConstraint
    attr_reader :version, :default

    def initialize(options)
      @version = options.fetch(:version)
      @default = options.fetch(:default)
    end

    def matches?(request)
      return true if default?

      request
        .headers
        .fetch(:accept)
        .include?("version=#{version}")
    end

    private

    def default?
      default
    end
  end
end

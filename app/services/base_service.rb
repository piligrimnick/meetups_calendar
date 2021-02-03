require "dry/monads/do"

class BaseService
  extend Dry::Initializer
  include Dry::Monads[:result, :try, :do]

  def call
    raise NotImplementedError
  end

  attr_reader :public_params

  private

  attr_reader :params

  class << self
    # Instantiates and calls the service at once
    def call(*args, &block)
      new(*args).call(&block)
    end

    # Accepts both symbolized and stringified attributes
    def new(*args)
      args << args.pop.symbolize_keys if args.last.is_a?(Hash)
      instance = super(*args)

      instance.instance_variable_set(:@public_params, dry_initializer.public_attributes(instance))
      instance.instance_variable_set(:@params, dry_initializer.attributes(instance))

      instance
    end
  end
end

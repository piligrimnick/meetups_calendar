class ContractResolver
  class ContractUndefined < NameError; end

  include Dry::Monads[:result]

  def initialize(args)
    @model_class = args[:class]
  end

  def validate(record)
    case contract_for(record).call(record.attributes).to_monad
    in Success then return
    in Failure(result)
      result.errors.to_h.each do |attribute, messages|
        messages.each do |message|
          record.errors.add(attribute, message)
        end
      end
    end
  end

  private

  attr_reader :model_class

  def contract_for(record)
    model_domain = model_class.to_s.pluralize
    action = record.new_record? ? 'Create' : 'Update'

    contract_class = "Contracts::#{model_domain}::#{action}"

    if Object.const_defined?(contract_class)
      return contract_class.safe_constantize.new
    end

    raise ContractUndefined.new("uninitialized constant: #{contract_class}")
  end
end

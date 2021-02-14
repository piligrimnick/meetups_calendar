module Contracts
  class BaseContract < Dry::Validation::Contract
    Dry::Validation.load_extensions(:predicates_as_macros)
    import_predicates_as_macros
  end
end

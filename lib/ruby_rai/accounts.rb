# frozen_string_literal: true
class RubyRai::Accounts
  attr_accessor :public_keys

  def initialize(public_keys)
    unless public_keys.is_a?(Array)
      raise RubyRai::MissingInitArguments,
            'Missing required init argument: public_keys (array)'
    end

    @public_keys = public_keys
  end

  def self.method_prefix
    :accounts
  end

  def self.model_params
    {
      accounts: :public_keys
    }
  end

  def self.model_methods
    {
      prefixed: {
        balances: nil,
        create: { required: %i[wallet count], optional: %i[work] },
        frontiers: nil,
        pending: { required: %i[count], optional: %i[threshold source] }
      }
    }
  end

  include RubyRai::MethodHelper
  instantiate_methods
end

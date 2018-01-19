# frozen_string_literal: true
class RubyRai::Accounts
  include RubyRai::MethodHelper

  attr_accessor :public_keys

  def initialize(public_keys)
    raise RubyRai::MissingInitArguments.new('Array of public_keys required') unless public_keys.is_a?(Array)
    @public_keys = public_keys
  end

  def self.method_prefix
    :accounts
  end

  def self.model_params
    {
      accounts: public_keys
    }
  end

  def self.prefixed_methods
    {
      balances: nil,
      create: { required: %i[wallet count], optional: %i[work] },
      frontiers: nil,
      pending: { required: %i[count], optional: %i[threshold source] }
    }
  end

  def self.raw_methods
    {}
  end

  instantiate_methods
end

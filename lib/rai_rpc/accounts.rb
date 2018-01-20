# frozen_string_literal: true
class RaiRpc::Accounts
  attr_accessor :addresses

  def initialize(addresses)
    unless addresses.is_a?(Array)
      raise RaiRpc::MissingArguments, 'Missing argument: addresses (str[])'
    end

    @addresses = addresses
  end

  def self.method_prefix
    'accounts_'
  end

  def self.model_params
    {
      accounts: :addresses
    }
  end

  def self.model_methods
    {
      balances: nil,
      create: { required: %i[wallet count], optional: %i[work] },
      frontiers: nil,
      pending: { required: %i[count], optional: %i[threshold source] }
    }
  end

  include RaiRpc::MethodHelper
  instantiate_methods
end

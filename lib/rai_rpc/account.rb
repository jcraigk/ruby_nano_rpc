# frozen_string_literal: true
class RaiRpc::Account
  attr_accessor :address

  def initialize(address)
    unless address.is_a?(String) || address.is_a?(Symbol)
      raise RaiRpc::MissingInitArguments,
            'Missing required argument: address (str)'
    end

    @address = address
  end

  def self.method_prefix
    :account
  end

  def self.model_params
    {
      account: :address
    }
  end

  def self.model_methods
    {
      prefixed: {
        balance: nil,
        block_count: nil,
        info: nil,
        create: { required: %i[wallet] },
        history: { required: %i[count] },
        list: nil,
        move: { required: %i[wallet source accounts] },
        key: nil,
        remove: { required: %i[wallet] },
        representative: nil,
        representative_set: { required: %i[wallet representative] },
        weight: nil
      },
      raw: {
        delegators: nil,
        delegators_count: nil,
        frontiers: { required: %i[count] },
        frontier_count: nil,
        ledger: { required: %i[count] },
        validate_account_number: nil,
        pending: { required: %i[count], optional: %i[threshold exists] }
      }
    }
  end

  include RaiRpc::MethodHelper
  instantiate_methods
end

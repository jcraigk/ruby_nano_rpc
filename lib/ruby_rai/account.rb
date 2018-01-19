# frozen_string_literal: true
class RubyRai::Account
  include RubyRai::MethodHelper

  attr_accessor :public_key

  def initialize(public_key)
    @public_key = public_key
  end

  def self.method_prefix
    :account
  end

  def self.model_params
    {
      account: :public_key
    }
  end

  def self.prefixed_methods
    {
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
    }
  end

  def self.raw_methods
    {
      delegators: nil,
      delegators_count: nil,
      frontiers: { required: %i[count] },
      frontier_count: nil,
      ledger: { required: %i[count] },
      validate_account_number: nil,
      pending: { required: %i[count], optional: %i[threshold exists] }
    }
  end

  instantiate_methods
end

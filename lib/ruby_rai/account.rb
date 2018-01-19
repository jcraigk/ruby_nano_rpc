# frozen_string_literal: true
class RubyRai::Account
  include RubyRai::ClientHelper

  attr_accessor :public_key

  def initialize(public_key)
    @public_key = public_key
  end

  PREFIXED_METHODS = {
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
  RAW_METHODS = {
    delegators: nil,
    delegators_count: nil,
    frontiers: { required: %i[count] },
    frontier_count: nil,
    ledger: { required: %i[count] },
    validate_account_number: nil,
    pending: { required: %i[count], optional: %i[threshold exists] }
  }
  PREFIXED_METHODS.each do |method_name, param_signature|
    define_rpc_method(method_name, param_signature, prefix: :account)
  end
  RAW_METHODS.each do |method_name, param_signature|
    define_rpc_method(method_name, param_signature)
  end
end

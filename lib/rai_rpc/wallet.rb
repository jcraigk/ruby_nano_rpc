# frozen_string_literal: true
class RaiRpc::Wallet
  attr_accessor :seed

  def initialize(wallet_seed)
    unless wallet_address.is_a?(String) || public_key.is_a?(Symbol)
      raise RaiRpc::MissingInitArguments,
            'Missing required argument: wallet_seed (str)'
    end

    @seed = wallet_seed
  end

  def self.method_prefix
    :wallet
  end

  def self.model_params
    {
      wallet: :seed
    }
  end

  def self.model_methods
    {
      prefixed: {
        # representative: nil,
        # representative_set: nil,
        # add: nil,
        # balance_total: nil,
        balances: nil,
        change_seed: { required: %i[seed] },
        contains: { required: %i[account] }
        create: nil,
        destroy: nil,
        export: nil,
        frontiers: nil,
        pending: { required: %i[count], optional: %i[threshold source] }
        republish: { required: %i[count] },
        work_get: nil,
        locked: nil
      }
      raw: {
        # search_pending: nil,
        # search_pending_all: nil,
        # send: nil,
        password_change: { required: %i[password] },
        password_enter: { required: %i[password] },
        password_valid: nil,
        work_get: nil,
        work_set: nil
      }
    }
  end

  include RaiRpc::MethodHelper
  instantiate_methods
end

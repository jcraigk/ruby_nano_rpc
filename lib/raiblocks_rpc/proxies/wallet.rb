# frozen_string_literal: true
class RaiblocksRpc::Wallet < RaiblocksRpc::Proxy
  attr_accessor :seed

  def initialize(wallet_seed)
    unless wallet_address.is_a?(String) || public_key.is_a?(Symbol)
      raise RaiblocksRpc::MissingArguments, 'Missing argument: wallet_seed (str)'
    end

    @seed = wallet_seed

    super
  end

  def model_params
    { wallet: :seed }
  end

  def model_methods
    {
      wallet_balances: nil,
      wallet_add: { required: %i[key], optional: %i[work] },
      password_change: { required: %i[password] },
      wallet_change_seed: { required: %i[seed] },
      wallet_contains: { required: %i[account] },
      wallet_create: nil,

      wallet_destroy: nil,
      wallet_export: nil,
      wallet_frontiers: nil,
      wallet_pending: { required: %i[count], optional: %i[threshold source] },
      wallet_republish: { required: %i[count] },
      wallet_work_get: nil,
      password_enter: { required: %i[password] },
      password_valid: nil,
      wallet_locked: nil,
      work_get: nil,
      work_set: nil


    }
  end
end

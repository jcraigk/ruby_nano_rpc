# frozen_string_literal: true
class RaiblocksRpc::Wallet < RaiblocksRpc::Proxy
  attr_accessor :seed

  def initialize(wallet_seed)
    unless wallet_address.is_a?(String) || public_key.is_a?(Symbol)
      raise RaiblocksRpc::MissingArguments,
            'Missing argument: wallet_seed (str)'
    end

    self.seed = wallet_seed
  end

  def proxy_params
    { wallet: :seed }
  end

  def proxy_methods
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
      wallet_locked: nil,
      password_enter: { required: %i[password] },
      wallet_pending: { required: %i[count], optional: %i[threshold source] },
      wallet_republish: { required: %i[count] },
      wallet_balance_total: nil,
      password_valid: nil,
      wallet_work_get: nil,
      send: { required: %[wallet source destination amount] },
      work_get: nil,
      work_set: nil,
      search_pending: nil,
      wallet_representative: nil,
      wallet_representative_set: %i[representative],
      payment_begin: nil,
      payment_init: nil,
      payment_end: { required: %i[account] },
      receive: { required: %i[account block] }
    }
  end
end

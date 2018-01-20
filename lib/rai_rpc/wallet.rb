# frozen_string_literal: true
class RaiRpc::Wallet
  attr_accessor :seed

  def initialize(wallet_seed)
    unless wallet_address.is_a?(String) || public_key.is_a?(Symbol)
      raise RaiRpc::MissingArguments, 'Missing argument: wallet_seed (str)'
    end

    @seed = wallet_seed
  end

  def self.method_prefix
    'wallet_'
  end

  def self.model_params
    {
      wallet: :seed
    }
  end

  def self.model_methods
    {
      wallet_balances: nil,
      wallet_change_seed: { required: %i[seed] },
      wallet_contains: { required: %i[account] },
      wallet_create: nil,
      wallet_destroy: nil,
      wallet_export: nil,
      wallet_frontiers: nil,
      wallet_pending: { required: %i[count], optional: %i[threshold source] },
      wallet_republish: { required: %i[count] },
      wallet_work_get: nil,
      password_change: { required: %i[password] },
      password_enter: { required: %i[password] },
      password_valid: nil,
      wallet_locked: nil,
      work_get: nil,
      work_set: nil


    }
  end

  include RaiRpc::MethodHelper
  instantiate_methods
end

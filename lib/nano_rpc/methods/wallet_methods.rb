# frozen_string_literal: true
module NanoRpc::WalletMethods
  def proxy_params
    { wallet: :id }
  end

  def proxy_methods # rubocop:disable Metrics/MethodLength
    {
      account_create: {
        optional: %i[work]
      },
      account_list: {},
      account_remove: {
        required: %i[account]
      },
      accounts_create: {
        required: %i[count],
        optional: %i[work]
      },
      password_change: {
        required: %i[password]
      },
      password_enter: {
        required: %i[password]
      },
      password_valid: {},
      payment_begin: {},
      payment_end: {
        required: %i[account]
      },
      payment_init: {},
      receive: {
        required: %i[account block],
        optional: %i[work]
      },
      search_pending: {},
      send: {
        required: %i[wallet source destination amount],
        optional: %i[id work]
      },
      wallet_add: {
        required: %i[key],
        optional: %i[work]
      },
      wallet_add_watch: {
        required: %i[accounts]
      },
      wallet_balances: {
        optional: %i[threshold]
      },
      wallet_change_seed: {
        required: %i[seed]
      },
      wallet_contains: {
        required: %i[account]
      },
      wallet_destroy: {},
      wallet_export: {},
      wallet_frontiers: {},
      wallet_info: {},
      wallet_ledger: {},
      wallet_locked: {},
      wallet_pending: {
        required: %i[count],
        optional: %i[threshold source include_active]
      },
      wallet_representative: {},
      wallet_representative_set: {
        required: %i[representative]
      },
      wallet_republish: {
        required: %i[count]
      },
      wallet_work_get: {},
      work_get: {
        required: %i[account]
      },
      work_set: {}
    }
  end
end

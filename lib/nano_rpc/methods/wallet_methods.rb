# frozen_string_literal: true
module NanoRpc::Methods::Wallet
  def method_signatures # rubocop:disable Metrics/MethodLength
    {
      account_create: {
        optional: %i[work]
      },
      accounts_create: {
        required: %i[count],
        optional: %i[work]
      },
      account_list: {},
      account_remove: {
        required: %i[account]
      },
      password_change: {
        required: %i[password]
      },
      password_enter: {
        required: %i[password]
      },
      password_valid: {},
      payment_begin: {},
      payment_init: {},
      payment_end: {
        required: %i[account]
      },
      receive: {
        required: %i[account block],
        optional: %i[work]
      },
      send: {
        required: %i[wallet source destination amount],
        optional: %i[id work]
      },
      search_pending: {},
      wallet_add: {
        required: %i[key],
        optional: %i[work]
      },
      wallet_add_watch: {
        required: %i[accounts]
      },
      wallet_balance_total: {},
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
      wallet_ledger: {},
      wallet_locked: {},
      wallet_pending: {
        required: %i[count],
        optional: %i[threshold source]
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

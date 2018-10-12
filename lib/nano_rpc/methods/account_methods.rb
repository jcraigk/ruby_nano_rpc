# frozen_string_literal: true
module NanoRpc::AccountMethods
  def proxy_params
    { account: :address }
  end

  def proxy_methods # rubocop:disable Metrics/MethodLength
    {
      account_balance: {},
      account_block_count: {},

      account_create: {
        required: %i[wallet],
        optional: %i[work]
      },
      account_history: {
        required: %i[count],
        optional: %i[raw head]
      },
      account_info: {},
      account_key: {},
      account_move: {
        required: %i[wallet source accounts]
      },
      account_remove: {
        required: %i[wallet]
      },
      account_representative: {},
      account_representative_set: {
        required: %i[wallet representative]
      },
      account_weight: {},
      delegators: {},
      delegators_count: {},
      frontiers: {
        required: %i[count]
      },
      ledger: {
        required: %i[count],
        optional: %i[representative weight pending modified_since sorting]
      },
      payment_wait: {
        required: %i[amount timeout]
      },
      pending: {
        required: %i[count],
        optional: %i[threshold exists source include_active]
      },
      receive: {
        required: %i[wallet block],
        optional: %i[work]
      },
      validate_account_number: {},
      work_get: {
        required: %i[wallet]
      },
      work_set: {}
    }
  end
end

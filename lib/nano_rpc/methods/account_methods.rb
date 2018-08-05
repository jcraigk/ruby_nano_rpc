# frozen_string_literal: true
module NanoRpc::Methods::Account
  def method_signatures
    {
      account_balance: {},
      account_block_count: {},
      account_info: {},
      account_create: { required: %i[wallet], optional: %i[work] },
      account_history: { required: %i[count] },
      account_move: { required: %i[wallet source accounts] },
      account_key: {},
      account_remove: { required: %i[wallet] },
      account_representative: {},
      account_representative_set: { required: %i[wallet representative] },
      account_weight: {},
      delegators: {},
      delegators_count: {},
      frontiers: { required: %i[count] },
      ledger: {
        required: %i[count],
        optional: %i[representative weight pending modified_since sorting]
      },
      validate_account_number: {},
      pending: {
        required: %i[count],
        optional: %i[threshold exists source]
      },
      payment_wait: { required: %i[amount timeout] },
      receive: { required: %i[wallet block], optional: %i[work] },
      work_get: { required: %i[wallet] },
      work_set: {}
    }
  end
end

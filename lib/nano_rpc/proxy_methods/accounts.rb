# frozen_string_literal: true
module NanoRpc::ProxyMethods::Accounts
  def proxy_params
    { accounts: :addresses }
  end

  def method_signatures # rubocop:disable Metrics/MethodLength
    {
      account_move: {
        required: %i[wallet source]
      },
      accounts_balances: {},
      accounts_create: {
        required: %i[wallet count],
        optional: %i[work]
      },
      accounts_frontiers: {},
      accounts_pending: {
        required: %i[count],
        optional: %i[threshold source]
      }
    }
  end
end

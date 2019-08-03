# frozen_string_literal: true

module NanoRpc
  # Signatures for Nano accounts RPC methods
  module AccountsMethods
    def proxy_params
      { accounts: :addresses }
    end

    def proxy_methods # rubocop:disable Metrics/MethodLength
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
          optional: %i[
            threshold source include_active
            sorting include_only_confirmed
          ]
        }
      }
    end
  end
end

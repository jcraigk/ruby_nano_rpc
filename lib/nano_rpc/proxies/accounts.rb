# frozen_string_literal: true
class Nano::Accounts
  include Nano::Proxy
  include Nano::AccountsHelper

  attr_reader :addresses

  def initialize(addresses = nil, opts = {})
    unless addresses.is_a?(Array)
      raise Nano::MissingParameters,
            'Missing argument: addresses (str[])'
    end

    @addresses = addresses
    super(opts)
  end

  proxy_params accounts: :addresses

  proxy_method :account_move, required: %i[wallet source]
  proxy_method :accounts_balances
  proxy_method :accounts_create, required: %i[wallet count], optional: %i[work]
  proxy_method :accounts_frontiers
  proxy_method :accounts_pending,
               required: %i[count], optional: %i[threshold source]
end

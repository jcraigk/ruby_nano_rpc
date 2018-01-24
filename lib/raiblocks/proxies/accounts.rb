# frozen_string_literal: true
class Raiblocks::Accounts
  include Raiblocks::Proxy
  include Raiblocks::AccountsProxyHelper

  attr_accessor :addresses

  def initialize(addresses = nil, client = nil)
    unless addresses.is_a?(Array)
      raise Raiblocks::MissingParameters,
            'Missing argument: addresses (str[])'
    end

    @addresses = addresses
    @client = client || Raiblocks.client
  end

  proxy_params accounts: :addresses

  proxy_method :accounts_balances
  proxy_method :accounts_create, required: %i[wallet count], optional: %i[work]
  proxy_method :accounts_frontiers
  proxy_method :accounts_pending,
               required: %i[count], optional: %i[threshold source]
end

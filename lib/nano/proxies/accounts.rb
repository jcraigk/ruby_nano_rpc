# frozen_string_literal: true
class Nano::Accounts
  include Nano::Proxy
  include Nano::AccountsProxyHelper

  attr_accessor :addresses

  def initialize(addresses = nil, client = nil)
    unless addresses.is_a?(Array)
      raise Nano::MissingParameters,
            'Missing argument: addresses (str[])'
    end

    @addresses = addresses
    @client = client || Nano.client
  end

  proxy_params accounts: :addresses

  proxy_method :accounts_balances
  proxy_method :accounts_create, required: %i[wallet count], optional: %i[work]
  proxy_method :accounts_frontiers
  proxy_method :accounts_pending,
               required: %i[count], optional: %i[threshold source]
end
